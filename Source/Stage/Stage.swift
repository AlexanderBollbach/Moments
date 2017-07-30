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
    let nodeManager = NodeManager()
    let stageView = StageView.shared
    let momentsCoordinator = MomentsCoordinator()
    
    
    func genID() -> String { IDMAker += 1 ; return String(IDMAker) }
    
    
    func run() {
        
        audioEngine.run()
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            
            
            self.nodeManager.tick()
            
            let viewMetrics = self.nodeManager.nodeViewMetrics()
            let audioMetrics = self.nodeManager.nodeAudioMetrics()
            
            self.stageView.update(with: viewMetrics)
            self.audioEngine.update(with: audioMetrics)
        }
    }
 
    

    
    
    
    
    
    

    
    
    
    // OPERATIONS
    
    
    
    fileprivate func addNode(at position : NodePosition) {
        
        let id = genID()
        nodeManager.addToneNode(id: id, at: position)
    }
    
    
    func updateNode(id: String, at position: NodePosition) {
        
        nodeManager.updatePosition(id: id, value: position)
    }
    
    
    fileprivate func addMoment() {
        momentsCoordinator.addMoment(nodes: nodeManager.allNode)
        stageView.flareAll()
    }
    
    
    fileprivate func nextMoment() {
        
        if let nextMoment = momentsCoordinator.nextMoment() {
            apply(moment: nextMoment)
        }
    }
    
    
    
    
    
    fileprivate func clear() {
        
        nodeManager.clear()
    
        momentsCoordinator.clear()
        
        audioEngine.clear()
    }
    
    
 
    // Helpers
    
    private func apply(moment: Moment) {
        nodeManager.apply(moment: moment)
    }

}

extension Stage: StageViewDelegate {
    
    func interacted(event: StageEvent) {
        
        switch event {
        case .tapped(let position):
            addNode(at: position)
            
        case .moved(let viewMovement):
            updateNode(id: viewMovement.id, at: viewMovement.position)
        }

    }
    
    func menuButtonTapped(button: MenuButton) {
        
        switch button {
        case .addMoment:
            addMoment()
        case .logMoments:
            momentsCoordinator.logMoments()
        case .nextMoment:
            nextMoment()
        case .clear:
            clear()
        }
    }
}
