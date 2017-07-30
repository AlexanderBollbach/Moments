//
//  NodeManager.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import Foundation

class NodeManager {
    
    var nodes = [Node]()
    
    var allNode: [Node] { return self.nodes }
    
    
    
    
    var timers = [String: Timer]()
    
    func clear() { self.nodes = [] }
    
    func add(node: Node) {
        
        switch node {
        case let node as ToneNode:
            addToneNode(id: node.id)
        default:
            break
        }
    }
    
    
    func addToneNode(id: String, at position: NodePosition = NodePosition.defaultPosition) {
        
        var node = ToneNode(id: id)
        node.position = position
        nodes.append(node)
    }
    
    
    
    
    // MOMENTS
    
    func apply(moment: Moment) {
        
        
        let newNodes = moment.nodes

        
        for newNode in newNodes {
            
            if let oldNodeIndex = index(id: newNode.id) {
                
                self.nodes[oldNodeIndex].targetPosition = newNode.position
            } else {
                // bring new node for moment alive
                var node = newNode
                node.health = 0.0
                node.shouldDie = false
                self.nodes.append(node)
            }
            
        }
        
        
        // kill off nodes not in new moment list
        for node in nodes {
            if !newNodes.contains(where: { $0.id == node.id }) {
                if let index = index(id: node.id) {
                    self.nodes[index].shouldDie = true
                    
                }
            }
        }
        
        
    }

    
    
    


   
    
    // AUDIO SUPPORT
    func nodeAudioMetrics() -> [NodeAudioMetrics] {
        return nodes.flatMap { audioMetricsForNode(id: $0.id) }
    }
    
    
    func index(id: String) -> Int? {
        
        guard let index = self.nodes.index(where: {  $0.id == id }) else { return nil }
        return index
    }
    
    func audioMetricsForNode(id: String) -> NodeAudioMetrics? {
        
        guard let node = (nodes.filter { $0.id == id }).first else { return nil }
     
        switch node {
        case let node as BaseNode:
            return NodeAudioMetrics(id: node.id, values: .baseNode)
        case let node as ToneNode:
            
            let volume = node.health * node.position.x
            let frequency = node.position.y * 2000
            
            return NodeAudioMetrics(id: id, values: .ToneNode(ToneNodeAudioMetrics(volume: volume, frequency: frequency)))
        default:
            return nil
        }
    }
    
    
    
    
    // DYNAMICS
    
    
    
    func tick() {
        
        
        let updateHealth = { (_ node: Node) in
            
            guard let index = self.index(id: node.id) else { return }
            
            if node.shouldDie {
                self.nodes[index].health -= 0.05
            } else {
                self.nodes[index].health += 0.05
            }
        }
        
        let judge = { (_ node: Node) in
            
            if node.health < 0.01 && node.shouldDie {
                self.remove(node)
            }
        }
        
        let updatePosition = { (_ node: Node) in
            
            guard let targetPosition = node.targetPosition else { return }
            guard let index = self.index(id: node.id) else { return }
            
            let oldPosition = self.nodes[index].position
            
            let deltaX = (targetPosition.x - oldPosition.x) / 10
            let deltaY = (targetPosition.y - oldPosition.y) / 10
            
            let xNext = oldPosition.x + deltaX
            let yNext = oldPosition.y + deltaY
            
            self.nodes[index].position = NodePosition(x: xNext, y: yNext)
            
            if self.nodes[index].isNearTargetPosition() {
                
                self.nodes[index].targetPosition = nil
            }
        }
        
        
        
        //         Core Logic
        
        for node in nodes {
            updatePosition(node)
            updateHealth(node)
            
            judge(node)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    // VIEW SUPPORT
    
    
    func nodeViewMetrics() -> [NodeViewMetrics] {
        return nodes.flatMap { viewMetricsForNode(id: $0.id) }
    }
    
    func viewMetricsForNode(id: String) -> NodeViewMetrics? {
        
        guard let node = self.node(id: id) else { return nil }
        
        switch node {
        case let node as BaseNode:
            return NodeViewMetrics(id: node.id, values: .baseNode)
        case let node as ToneNode:
            return NodeViewMetrics(id: id, values: .toneNode(ToneNodeViewMetrics(size: node.size, position: node.position, health: node.health)))
        default:
            return nil
        }
    }
    

    // MUTATION
 

    func updatePosition(id: String, value: NodePosition) {
        guard let index = nodes.index(where: { $0.id == id }) else { return }
        nodes[index].position = value
    }
    
    

    
    
    
    
    
    // HELPERS
    
    private func node(id: String) -> Node? {
        
        guard let node = (nodes.filter { $0.id == id }).first else { return nil }
        return node
    }
    
    
    private func remove(_ node: Node) {
        
        if let index = index(id: node.id) {
            self.nodes.remove(at: index)
        }
    }
    
    
    func getNode(id: String) -> Node? {
        return (self.nodes.filter { $0.id == id }).first
        
    }

}
