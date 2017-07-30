//
//  ABAudioEngine.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/26/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import AVFoundation

protocol NodeUnit {
    var id: String { get }
    
    var auAudioUnit: AUAudioUnit { get }
    var avAudioUnit: AVAudioUnit { get }
}

protocol Level: NodeUnit {
    var volume: Double { get set }
}

protocol Frequency: NodeUnit {
    var frequency: Double { get set }
}

struct BaseNodeUnit: NodeUnit {
    let id: String
    
    var auAudioUnit: AUAudioUnit
    var avAudioUnit: AVAudioUnit
}

struct ToneNodeUnit: NodeUnit, Level, Frequency {
    let id: String
    
    var auAudioUnit: AUAudioUnit
    var avAudioUnit: AVAudioUnit
    
    var frequency: Double
    var volume: Double
}

class AudioEngine {
    
    let audioEngine = AVAudioEngine()
    var hardwareFormat: AVAudioFormat!
    let stereoFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
    
    var units = [NodeUnit]()
    
    init() {
        hardwareFormat = audioEngine.outputNode.outputFormat(forBus: 0)
        audioEngine.connect(audioEngine.mainMixerNode, to: audioEngine.outputNode, format: hardwareFormat)

        do { try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback) } catch (let error) { print("\(error)")
            return }
        do { try AVAudioSession.sharedInstance().setActive(true) } catch (let error) { print("\(error)")
            return }
        
        let desc = AudioComponentDescription(componentType: kAudioUnitType_Generator, componentSubType: 0x6d617533, componentManufacturer: 0x4d415533, componentFlags: 0, componentFlagsMask: 0)
        
        AUAudioUnit.registerSubclass(MyAudioUnit3.self, as: desc, name: "MyAudioUnit3", version: 1)
    }
    
    func run() { do { try audioEngine.start() } catch (let error) { fatalError("\(error)") } }
    
    func addToneGenerator(id: String) {
        buildToneGenerator { unit in
            self.audioEngine.attach(unit)
            self.audioEngine.connect(unit, to: self.audioEngine.mainMixerNode, format: self.stereoFormat)
            self.units.append(ToneNodeUnit(id: id, auAudioUnit: unit.auAudioUnit, avAudioUnit: unit, frequency: 0, volume: 0))
        }
    }
    
    func buildToneGenerator(completed: @escaping (AVAudioUnit) -> Swift.Void) {
        
        let desc = AudioComponentDescription(componentType: kAudioUnitType_Generator, componentSubType: 0x6d617533, componentManufacturer: 0x4d415533, componentFlags: 0, componentFlagsMask: 0)
        
        AVAudioUnit.instantiate(with: desc, options: .loadOutOfProcess) { (unit, error) in
            guard error == nil else { fatalError("couldn't instantiate audio unit") }
            unit?.auAudioUnit.maximumFramesToRender = 256
            completed(unit!)
        }
    }
    
    
    func update(newNodes: [Node]) {
        
        newNodes.forEach { updateUnit(node: $0) }
        
        muteAllNotInSet(nodes: newNodes)
    }
    
    
    func muteAllNotInSet(nodes: [Node]) {
        
        for unit in units {
            if !nodes.contains(where: { $0.id == unit.id }) {
                if let volumeUnit = unit as? ToneNodeUnit {
                    self.mute(unit: volumeUnit)
                }
            }
        }
    }
    
    
    func mute(unit: Level) {
        set(id: unit.id, auParam: "volume", value: 0)
    }
    

    func updateUnit(node: AudioMetrics) {
        switch node {
        case let node as ToneNodeAudioMetrics: updateToneNodeUnit(node: node)
        default: break
        }
    }
    
    private func updateToneNodeUnit(node: ToneNodeAudioMetrics) {
        set(id: node.id, auParam: "frequency", value: node.frequency)
        set(id: node.id, auParam: "volume", value: node.volume)
    }
  
    private func set(id: String, auParam: String, value: Double) {
        
        guard let index = (self.units.index { $0.id == id }) else { return }
        
        let auUnit = self.units[index].auAudioUnit

        let freqParam = auUnit.parameterTree?.value(forKey: auParam) as? AUParameter
        freqParam?.value = AUValue(value)
    }
}
