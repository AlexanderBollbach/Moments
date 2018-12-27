import Foundation

class NodeController {
    
    var nodes = [Node]()
    
    var allNodes: [Node] {
        return self.nodes
    }
    
    func clear() {
        self.nodes = []
    }
    
    func add(node: Node) {
        
        switch node {
        
        case let node as ToneNode:
            addToneNode(id: node.id)
        
        default:
            break
        }
    }
    
    
    func addToneNode(id: String, at position: NodePosition = .defaultPosition) {
        var node = ToneNode(id: id)
        node.position = position
        nodes.append(node)
    }
    
    // MOMENTS
    
    func apply(moment: Moment) {
        
        let newNodes = moment.nodes

        for newNode in newNodes {
            
            if let oldNodeIndex = index(id: newNode.id) {
                nodes[oldNodeIndex].targetPosition = newNode.position
            } else {
                // bring new node for moment alive
                var node = newNode
                node.health = 0.0
                node.shouldDie = false
                nodes.append(node)
            }
        }
        
        for node in nodes where !newNodes.contains(where: { $0.id == node.id }) {
            guard let index = index(id: node.id) else { fatalError("should have index") }
            nodes[index].shouldDie = true
        }
    }
    
    func tick() {

        let updateHealth = { [unowned self] (_ node: Node) in
            
            guard let index = self.index(id: node.id) else { return }
            
            if node.shouldDie {
                self.nodes[index].health -= 0.05
            } else {
                self.nodes[index].health += 0.05
            }
        }
        
        let judge = { [unowned self]  (_ node: Node) in
            
            if node.health < 0.01 && node.shouldDie {
                self.remove(node)
            }
        }
        
        let updatePosition = { [unowned self] (_ node: Node) in
            
            guard
                let targetPosition = node.targetPosition,
                let index = self.index(id: node.id) else { return }
            
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
        
        for node in nodes {
            updatePosition(node)
            updateHealth(node)
            judge(node)
        }
    }
    
    func updatePosition(id: String, value: NodePosition) {
        guard let index = nodes.index(where: { $0.id == id }) else { return }
        nodes[index].position = value
    }
    
    func node(id: String) -> Node? {
        return nodes.first(where: { $0.id == id })
    }
    
    private func remove(_ node: Node) {
        guard let index = index(id: node.id) else { fatalError("why call with node?") }
        nodes.remove(at: index)
    }
    
    func index(id: String) -> Int? {
        return nodes.index(where: {  $0.id == id })
    }
}

// MARK: - metrics

extension NodeController {
    
    func nodeViewMetrics() -> [ViewMetrics] {
        return nodes
            .map { $0.id }
            .flatMap(viewMetricsForNode)
    }
    
    func viewMetricsForNode(id: String) -> ViewMetrics? {
        
        guard let node = self.node(id: id) else { return nil }
        
        switch node {
            
        case let node as BaseNode:
            return ViewMetrics(
                id: node.id,
                values: .baseNode
            )
            
        case let node as ToneNode:
            return ViewMetrics(
                id: id,
                values: .toneNode(
                    ToneNodeViewMetrics(
                        size: node.size,
                        position: node.position,
                        health: node.health
                    )
                )
            )
            
        default:
            return nil
        }
    }
    
    func nodeAudioMetrics() -> [AudioMetrics] {
        return nodes
            .map { $0.id }
            .flatMap(audioMetricsForNode)
    }

    func audioMetricsForNode(id: String) -> AudioMetrics? {
        
        guard let node = (nodes.filter { $0.id == id }).first else { return nil }
        
        switch node {
            
        case let node as BaseNode:
            return AudioMetrics(id: node.id, values: .baseNode)
            
        case let node as ToneNode:
            let volume = node.health * node.position.x
            let frequency = node.position.y * 2000
            
            return AudioMetrics(id: id, values: .ToneNode(ToneNodeAudioMetrics(volume: volume, frequency: frequency)))
            
        default:
            return nil
        }
    }
}
