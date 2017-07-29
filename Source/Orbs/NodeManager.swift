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
    
    
    var nodes = [Node]()
    
    
    func addToneNode(id: String, at position: NodePosition = NodePosition.defaultPosition) {
        
        var node = ToneNode(id: id)
        node.position = position
        
        self.nodes.append(node)
        
    }
    
    func allNodes() -> [Node] {
        return self.nodes
    }
    
    func getNode(id: String) -> Node? {
        return (self.nodes.filter { $0.id == id }).first
    }
    
    func updateNode(metrics: NodeMovementMetrics) {
        
        guard let node = getNode(id: metrics.id) else { return }
        
        // base node stuff
        updatePosition(id: node.id, value: metrics.nodePosition)
        
        // refined
        switch node {
        case let node as ToneNode:
            updateFrequency(id: node.id, value: metrics.nodePosition.x * 1000)
            updateVolume(id: node.id, value: metrics.nodePosition.y)
        default:
            break
        }
        
        print(node)
    }
    
    func audioForNode(id: String) -> AudioMetrics? {
        
        guard let node = (nodes.filter { $0.id == id }).first else { return nil }
        
        switch node {
        case let node as ToneNode:
            return node
        default:
            break
        }
        
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MUTATION
    
    func updateFrequency(id: String, value: Double) {
        
        guard let index = nodes.index(where: { $0.id == id }),
            var node = nodes[index] as? ToneNode else { return }
        
        node.frequency = value
        nodes[index] = node
    }
    
    
    func updateVolume(id: String, value: Double) {
        
        guard let index = nodes.index(where: { $0.id == id }),
            var node = nodes[index] as? ToneNode else { return }
        
        node.volume = value
        nodes[index] = node
    }
    
    
    func updatePosition(id: String, value: NodePosition) {
        
        guard let index = nodes.index(where: { $0.id == id }) else { return }
        
        nodes[index].position = value
        
    }
    
    
    
    
}
