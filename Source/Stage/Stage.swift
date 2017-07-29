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
    
    let nodeManager = NodeManager.shared
    
    let stageView = StageView.shared
    
    
    fileprivate func addNode(at position : NodePosition) {
        
        let id = genID()
        nodeManager.addSinNode(id: id, at: position)
        stageView.addNode(id: id)
        
        updateViewState()
    }
    
    
    func updateViewState() {
        stageView.update(with: nodeManager.allNodes())
        stageView.layoutIfNeeded()
    }
    
    func genID() -> String {
        IDMAker += 1
        return String(IDMAker)
    }
    
    func updateNode(metrics: NodeMovementMetrics) {
        nodeManager.updateNode(metrics: metrics)
    }
}

extension Stage: StageViewDelegate {
    
    func interacted(event: StageEvent) {
        
        switch event {
        case .tapped(let position):
            addNode(at: position)
        case .NodeMoved(let metrics):
            updateNode(metrics: metrics)
            
            
        }
    }
    
}
