//
//  OrbManager.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import Foundation

class OrbManager {
    
    static let shared = OrbManager()
    
    let engine = AudioEngine.shared
    
    var IDMAker = 0
    
    var orbs = [String: Orb]()
    
    
    func addSinOrb(id: String) {
        
        let orb = Orb(id: id)
        
        self.orbs[id] = orb
        
        engine.addSinGenerator(identifier: id) { }
    }
    
    func allOrbs() -> [Orb] {
        
        let orbList = orbs.map { $0.1 }
        return orbList
    }
    

    
}
