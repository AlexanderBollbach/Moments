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
    
    var orbs = [Orb]()
    
    
    func addSinOrb(id: String, at position: OrbPosition = OrbPosition.defaultPosition) {
        
        let orb = SinOrb(id: id)
        orb.position = position
        
        self.orbs.append(orb)
        
        engine.addSinGenerator(identifier: id) { }
    }
    
    func allOrbs() -> [Orb] {
        return self.orbs
    }
    
    func getOrb(id: String) -> Orb? {
        return (self.orbs.filter { $0.id == id }).first
    }
    
    func updateOrb(metrics: OrbMovementMetrics) {
        
        guard let orb = getOrb(id: metrics.id) else { return }
        
        orb.position = metrics.orbPosition
        
        updateOrbSettings(orb: orb, metrics: metrics)
        engine.updateUnit(orb: orb)
    }
    
    
    func updateOrbSettings(orb: Orb, metrics: OrbMovementMetrics) {
        
        switch orb {
        case let orb as SinOrb:
            orb.frequency = metrics.orbPosition.x * 1000
        default:
            break
        }
        
    }

    
}
