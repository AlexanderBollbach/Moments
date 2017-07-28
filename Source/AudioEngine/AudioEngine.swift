//
//  ABAudioEngine.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/26/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import AVFoundation


protocol Unit {
    
    var identifier: String { get }
}

struct SinUnit: Unit {
    
    let identifier: String
    
    var auAudioUnit: AUAudioUnit
    var avAudioUnit: AVAudioUnit
}

class AudioEngine {
    
    static let shared = AudioEngine()
    
    let audioEngine = AVAudioEngine()
    var hardwareFormat: AVAudioFormat!
    
    var units = [String: Unit]()
    
    init() {
        
        hardwareFormat = audioEngine.outputNode.outputFormat(forBus: 0)
        audioEngine.connect(audioEngine.mainMixerNode, to: audioEngine.outputNode, format: hardwareFormat)
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch (let error) {
            print("\(error)")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch (let error) {
            print("\(error)")
            return
        }
        
        let desc = AudioComponentDescription(componentType: kAudioUnitType_Generator, componentSubType: 0x6d617533, componentManufacturer: 0x4d415533, componentFlags: 0, componentFlagsMask: 0)
        
        AUAudioUnit.registerSubclass(MyAudioUnit3.self, as: desc, name: "MyAudioUnit3", version: 1)
        
    }
    
    func run() {
        do {
            try audioEngine.start()
        } catch (let error) {
            fatalError("\(error)")
        }
    }
    
    func addSinGenerator(identifier: String, completed: @escaping () -> Void) {
        
        let stereoFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
        
        buildSinGenerator { unit in
            
           
            self.audioEngine.attach(unit)
            self.audioEngine.connect(unit, to: self.audioEngine.mainMixerNode, format: stereoFormat)

            let newUnit = SinUnit(identifier: identifier, auAudioUnit: unit.auAudioUnit, avAudioUnit: unit)
            
            self.units[identifier] = newUnit
            
            completed()
        }
    }
    
    func buildSinGenerator(completed: @escaping (AVAudioUnit) -> Swift.Void) {
        
        let desc = AudioComponentDescription(componentType: kAudioUnitType_Generator, componentSubType: 0x6d617533, componentManufacturer: 0x4d415533, componentFlags: 0, componentFlagsMask: 0)
        
        AVAudioUnit.instantiate(with: desc, options: .loadOutOfProcess) { (unit, error) in
            guard error == nil else { fatalError("couldn't instantiate audio unit") }
            unit?.auAudioUnit.maximumFramesToRender = 256
            completed(unit!)
        }
    }
    
    
 
    
    
    func updateUnit(orb: OrbAudio) {
        
        
        switch orb {
        case let orb as SinAudio:
            updateSinUnit(orb: orb)
        default: break
        }
        
    }
    
    
    private func updateSinUnit(orb: SinAudio) {
        
        setFrequency(identifier: orb.id, value: orb.frequency)
    }
    
    
    
    
    
    
    private func setFrequency(identifier: String, value: Double) {
        
        guard let sinUnit = self.units[identifier] as? SinUnit else { return }
        
        let auUnit = sinUnit.auAudioUnit
        
        let paramTree = auUnit.parameterTree
        
        let freqParam = paramTree?.value(forKey: "frequency") as? AUParameter
        
        if let freq = freqParam {
            freq.value = AUValue(value)
        }
    }
    
    
}
