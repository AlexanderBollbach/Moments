import AVFoundation

protocol AudioNode {
    var id: String { get }
    
    var auAudioUnit: AUAudioUnit { get }
    var avAudioUnit: AVAudioUnit { get }
}

protocol HasLevel: AudioNode {
    var volume: Double { get set }
}

protocol HasFrequency: AudioNode {
    var frequency: Double { get set }
}

struct BaseAudioNode: AudioNode {
    let id: String
    
    var auAudioUnit: AUAudioUnit
    var avAudioUnit: AVAudioUnit
}

struct ToneAudioNode: AudioNode, HasLevel, HasFrequency {
    let id: String
    
    var auAudioUnit: AUAudioUnit
    var avAudioUnit: AVAudioUnit
    
    var frequency: Double
    var volume: Double
}
