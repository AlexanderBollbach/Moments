//
//  Node.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import UIKit


protocol Freezable {
    
    var id: String { get }
    
//    func freeze() ->
}

class Node: NodeViewConfig, NodeAudio {
    
    let id: String
    
    // audio
    var volume = 0.0
    
    // view
    var size: NodeSize = .small
    var position = NodePosition(x: 0.5, y: 0.5)
    
    init(id: String) {
        self.id = id
    }
}


class SinNode: Node, SinAudio {
    
    var frequency = 0.0
    
    override init(id: String) {
        super.init(id: id)

    }
}



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

protocol NodeAudio {
    var id: String { get }
    var volume: Double { get }
}

protocol SinAudio: NodeAudio {

    var frequency: Double { get }
}

