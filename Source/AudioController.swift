import AVFoundation

class AudioController {
    
    let audioEngine = AVAudioEngine()
    var hardwareFormat: AVAudioFormat!
    let stereoFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
    
    var units = [AudioNode]()
    
    init() {
        hardwareFormat = audioEngine.outputNode.outputFormat(forBus: 0)
        
        audioEngine.connect(
            audioEngine.mainMixerNode,
            to: audioEngine.outputNode,
            format: hardwareFormat
        )

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
        
        let desc = AudioComponentDescription(
            componentType: kAudioUnitType_Generator,
            componentSubType: 0x6d617533,
            componentManufacturer: 0x4d415533,
            componentFlags: 0,
            componentFlagsMask: 0
        )
        
        AUAudioUnit.registerSubclass(
            MyAudioUnit3.self,
            as: desc,
            name: "MyAudioUnit3", version: 1
        )
    }
    
    func run() {
        do {
            try audioEngine.start() }
        catch (let error) {
            fatalError("\(error)")
        }
    }
    
    
    func addToneGenerator(id: String, completion: (() -> Void)?) {
        
        buildToneGenerator { [unowned self] unit in
            
            self.audioEngine.attach(unit)
            
            self.audioEngine.connect(
                unit,
                to: self.audioEngine.mainMixerNode,
                format: self.stereoFormat
            )
            
            self.units.append(
                ToneAudioNode(
                    id: id,
                    auAudioUnit: unit.auAudioUnit,
                    avAudioUnit: unit,
                    frequency: 0,
                    volume: 0
                )
            )
            
            completion?()
        }
    }
    
    func buildToneGenerator(completed: @escaping (AVAudioUnit) -> Void) {
        
        let desc = AudioComponentDescription(
            componentType: kAudioUnitType_Generator,
            componentSubType: 0x6d617533,
            componentManufacturer: 0x4d415533,
            componentFlags: 0,
            componentFlagsMask: 0
        )
        
        AVAudioUnit.instantiate(with: desc, options: .loadOutOfProcess) { (unit, error) in
            guard error == nil else { fatalError("couldn't instantiate audio unit") }
            unit?.auAudioUnit.maximumFramesToRender = 256
            completed(unit!)
        }
    }
    
    func update(with metrics: [NodeAudioMetrics]) {
 
        for m in metrics {
            if !units.contains(where: { unit in unit.id == m.id }) {
                addToneGenerator(id: m.id, completion: nil)
            }
        }
        
        for unit in units {
            if !metrics.contains(where: { $0.id == unit.id }) {
                mute(id: unit.id)
            }
        }
        
        metrics.forEach {
            switch $0.values {
            case .baseNode:
                break
            case .ToneNode(let metrics):
                updateToneUnit(id: $0.id, metrics: metrics)
            }
        }
    }
    
    private func updateToneUnit(id: String, metrics: ToneNodeAudioMetrics) {
        set(id: id, auParam: "frequency", value: metrics.frequency)
        set(id: id, auParam: "volume", value: metrics.volume)
    }
  
    private func set(id: String, auParam: String, value: Double) {
        guard let index = (units.index { $0.id == id }) else { return }
        let auUnit = units[index].auAudioUnit
        let freqParam = auUnit.parameterTree?.value(forKey: auParam) as? AUParameter
        freqParam?.value = AUValue(value)
    }
    
    func clear() {
        
        for unit in units {
            audioEngine.disconnectNodeOutput(unit.avAudioUnit)
            audioEngine.detach(unit.avAudioUnit)
        }
        
        units = []
    }
    
    
    func remove(id: String) {
        guard let unitToRemove = units.first(where: { $0.id == id }) else { return }
        
        audioEngine.disconnectNodeInput(unitToRemove.avAudioUnit)
        audioEngine.detach(unitToRemove.avAudioUnit)
    }
    
    private func mute(id: String) {
        set(id: id, auParam: "volume", value: 0)
    }
}
