//
//  NodeManager.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import Foundation

class NodeManager {
    
    static let shared = NodeManager()
    
    let engine = AudioEngine.shared
    
    var IDMAker = 0
    
    var nodes = [Node]()
    
    
    func addSinNode(id: String, at position: NodePosition = NodePosition.defaultPosition) {
        
        let node = SinNode(id: id)
        node.position = position
        
        self.nodes.append(node)
        
        engine.addSinGenerator(identifier: id) { }
    }
    
    func allNodes() -> [Node] {
        return self.nodes
    }
    
    func getNode(id: String) -> Node? {
        return (self.nodes.filter { $0.id == id }).first
    }
    
    func updateNode(metrics: NodeMovementMetrics) {
        
        guard let node = getNode(id: metrics.id) else { return }
        
        node.position = metrics.nodePosition
        
        updateNodeSettings(node: node, metrics: metrics)
        engine.updateUnit(node: node)
    }
    
    
    func updateNodeSettings(node: Node, metrics: NodeMovementMetrics) {
        
        switch node {
        case let node as SinNode:
            node.frequency = metrics.nodePosition.x * 1000
            node.volume = metrics.nodePosition.y
        default:
            break
        }
        
        print(node)
    }

    
}
