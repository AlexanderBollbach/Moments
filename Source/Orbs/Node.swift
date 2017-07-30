//
//  Node.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import UIKit


protocol Node: NodeViewConfig, AudioMetrics {
    var id: String { get }
    
    var size: NodeSize { get set }
    var position: NodePosition { get set }
}

struct BaseNode: Node, NodeViewConfig {
    
    let id: String

    // view
    var size: NodeSize = .small
    var position = NodePosition(x: 0.5, y: 0.5)
}






struct ToneNode: Node, ToneNodeAudioMetrics {
    
    let id: String
    
    // audio
    var volume = 0.0
    var frequency = 0.0
    
    // view
    var size: NodeSize = .small
    var position = NodePosition(x: 0.5, y: 0.5)
    
    init(id: String, volume: Double = 0, frequency: Double = 0) {
        self.id = id
        self.volume = volume
        self.frequency = frequency
    }
}












// VIEW
struct NodePosition: Equatable {
    let x: Double
    let y: Double
    
    static let defaultPosition = NodePosition(x: 0.5, y: 0.5)
}
func ==(lhs: NodePosition, rhs: NodePosition) -> Bool { return lhs.x == rhs.x  && lhs.y == rhs.y }



enum NodeSize {
    
    case small
    case medium
    case large
    
    var sizeInPoints: CGFloat {
        switch self {
        case .small:
            return 0.1
        case .medium:
            return 0.2
        case .large:
            return 0.35
        }
    }
}

protocol NodeViewConfig {
    
    var size: NodeSize { get }
    var position: NodePosition { get }
}

protocol AudioMetrics {
    var id: String { get }
}

protocol ToneNodeAudioMetrics: AudioMetrics {
    var frequency: Double { get }
    var volume: Double { get }
}

enum NodeAudio {
    case toneNode(ToneNodeAudioMetrics)
}



