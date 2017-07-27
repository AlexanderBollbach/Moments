//
//  ABAudioEngine.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/26/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import AVFoundation

class ABAudioEngine {
    
    let audioEngine = AVAudioEngine()
    var hardwareFormat: AVAudioFormat!
    
    var nodes = [SoundNode]()
    
    var audioUnits = [String: AVAudioUnit]()
    
    static var nodeIdentifierCount = 0
    
    init() {
        
        hardwareFormat = audioEngine.outputNode.outputFormat(forBus: 0)
        audioEngine.connect(audioEngine.mainMixerNode, to: audioEngine.outputNode, format: hardwareFormat)
//        audioEngine.manualRenderingMaximumFrameCount = 256
        
        
        
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
    
    func addSinGenerator(completed: @escaping (SoundNode) -> Void) {
        
        let stereoFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
        
        buildSinGenerator { unit in
            
            let nodeID = String(ABAudioEngine.nodeIdentifierCount)
            ABAudioEngine.nodeIdentifierCount += 1
            
            self.audioEngine.attach(unit)
            self.audioEngine.connect(unit, to: self.audioEngine.mainMixerNode, format: stereoFormat)

            
            // add node
            let node = SoundNode(identifier: nodeID)
            self.nodes.append(node)
            self.audioUnits[nodeID] = unit
            
            completed(node)
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
    
    
    func setFrequency(node: SoundNode, value: Double) {
        
        let audioUnit = self.audioUnits[node.identifier]
        
        let paramTree = audioUnit?.auAudioUnit.parameterTree
        
        let freqParam = paramTree?.value(forKey: "frequency") as? AUParameter
        
        if let freq = freqParam {
            freq.value = AUValue(value)
        }
        
    }
    
    
}
