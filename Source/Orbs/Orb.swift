//
//  Orb.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import Foundation

struct Orb: OrbViewConfig {
    
    let id: String

    var frequency = 0.0
    
    var view: OrbView?
    
    init(id: String) {
        self.id = id
    }
    
    var size: OrbSize = .small
    
    var position = OrbPosition(x: 0.5, y: 0.5)
}


struct OrbPosition {
    let x: Double
    let y: Double
}

