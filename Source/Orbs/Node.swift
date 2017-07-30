//
//  Node.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import UIKit





// NODE

protocol Node {
    var id: String { get }
    
    var size: NodeSize { get set }
    var position: NodePosition { get set }
    var health: Double { get set }
    
    
    var targetPosition: NodePosition? { get set }
    var targetHealth: Double? { get set }
    
    
    var shouldDie: Bool { get set }
}

extension Node {
    
    func isNearTargetPosition() -> Bool {
        guard let targetPos = self.targetPosition else { return false }
        return abs(targetPos.x - self.position.x) < 0.001 && abs(targetPos.y - self.position.y) < 0.001
    }
    
    
    func isNearTargetHealth() -> Bool {
        guard let targetHealth = self.targetHealth else { return false }
        return abs(targetHealth - self.health) < 0.001
    }
    
    
    
}

struct BaseNode: Node {
    
    let id: String

    // view
    var size: NodeSize = .small
    var position = NodePosition(x: 0.5, y: 0.5)
    
    
    var targetPosition: NodePosition?
    
    var health: Double = 1.0 {
        didSet {
            if health > 1.0 {
                self.health = 1.0
            }
            
            if health < 0.0 {
                self.health = 0.0
            }
        }
    }
    
    var targetHealth: Double?
    
    var shouldDie: Bool = false
}


struct ToneNode: Node {
    
    let id: String

    var size: NodeSize = .small
    var position = NodePosition(x: 0.5, y: 0.5)
    
    init(id: String) {
        self.id = id
    }
    
    
    var targetPosition: NodePosition?
    
    var health: Double = 1.0 {
        didSet {
            if health > 1.0 {
                self.health = 1.0
            }
            
            if health < 0.0 {
                self.health = 0.0
            }
        }
    }
    
    var targetHealth: Double?
    
    var shouldDie: Bool = false
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


typealias NodeHealth = Double

struct ToneNodeViewMetrics {
    let size: NodeSize
    let position: NodePosition
    let health: NodeHealth
}

enum NodeViewMetricsValues {
    
    case baseNode
    case toneNode(ToneNodeViewMetrics)
}

struct NodeViewMetrics {
    let id: String
    let values: NodeViewMetricsValues
}













// AUDIO


struct ToneNodeAudioMetrics {
    let volume: Double
    let frequency: Double
}

enum NodeAudioMetricsValues {
    case baseNode
    case ToneNode(ToneNodeAudioMetrics)
}

struct NodeAudioMetrics {
    let id: String
    let values: NodeAudioMetricsValues
}





