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
    
    let audioEngine = AudioEngine()
    let nodeManager = NodeManager.shared
    let stageView = StageView.shared
    let momentsCoordinator = MomentsCoordinator()
    
    fileprivate func addNode(at position : NodePosition) {
        let id = genID()
        nodeManager.addToneNode(id: id, at: position)
        stageView.addNode(id: id)
        audioEngine.addToneGenerator(id: id)
        updateViewState()
    }
    
    func updateViewState() {
        stageView.update(with: nodeManager.allNodes())
        stageView.layoutIfNeeded()
    }
    
    func genID() -> String { IDMAker += 1 ; return String(IDMAker) }
    
    func updateNode(metrics: NodeMovementMetrics) {
        nodeManager.updateNode(metrics: metrics)
        if let audio = nodeManager.audioForNode(id: metrics.id) { audioEngine.updateUnit(node: audio) }
    }
    
    
    func apply(moment: Moment) {
        
        let newNodes = moment.nodes
        
        nodeManager.update(newNodes: newNodes)
        stageView.replaceNodes(with: newNodes)
        
        audioEngine.update(newNodes: newNodes)
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
    
    func menuButtonTapped(button: MenuButton) {
        switch button {
        case .addMoment:
            momentsCoordinator.addMoment(nodes: nodeManager.allNodes())
        case .logMoments:
            momentsCoordinator.logMoments()
        case .nextMoment:
            apply(moment: momentsCoordinator.nextMoment())
        }
    }
}
