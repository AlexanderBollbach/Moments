//
//  Stage.swift
//  Orbs
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import Foundation

class Stage {
    
    var IDMAker = 0
    
    static let shared = Stage()
    
    let audioEngine = AudioEngine.shared
    
    let orbManager = OrbManager.shared
    
    let stageView = StageView.shared
    
    
    fileprivate func addOrb() {
        
        let id = genID()
        
        orbManager.addSinOrb(id: id)
        
        stageView.addOrb(id: id)
        
        updateViewState()
    }
    
    
    func updateViewState() {
        stageView.update(with: orbManager.allOrbs())
        stageView.layoutIfNeeded()
    }
    
    func genID() -> String {
        IDMAker += 1
        return String(IDMAker)
    }
    
    func updateOrb(metrics: OrbMovementMetrics) {
        orbManager.updateOrb(metrics: metrics)
    }
}

extension Stage: StageViewDelegate {
    
    func interacted(event: StageEvent) {
        
        switch event {
        case .tapped:
            addOrb()
        case .OrbMoved(let metrics):
            updateOrb(metrics: metrics)
            
            
        }
    }
    
}
