//
//  Orb.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import UIKit

enum AudioType {
    case generic
    case sin
}

class Orb: OrbViewConfig, OrbAudio {
    
    let id: String
    var audioType: AudioType = .generic
    
    // audio
    var volume = 0.0
    
    // view
    var size: OrbSize = .small
    var position = OrbPosition(x: 0.5, y: 0.5)
    
    init(id: String) {
        self.id = id
    }
}


class SinOrb: Orb, SinAudio {
    
    var frequency = 0.0
    
    override init(id: String) {
        super.init(id: id)
        
        audioType = .sin
    }
    
}


struct OrbPosition: Equatable {
    let x: Double
    let y: Double
    
    static let defaultPosition = OrbPosition(x: 0.5, y: 0.5)
}
func ==(lhs: OrbPosition, rhs: OrbPosition) -> Bool { return lhs.x == rhs.x  && lhs.y == rhs.y }



enum OrbSize {
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

protocol OrbViewConfig {
    
    var size: OrbSize { get }
    var position: OrbPosition { get }
}

protocol OrbAudio {
    var id: String { get }
    var volume: Double { get }
}

protocol SinAudio: OrbAudio {

    var frequency: Double { get }
}

