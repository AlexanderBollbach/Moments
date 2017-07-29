//
//  StageView.swift
//  nodes
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import UIKit

protocol StageViewDelegate: class {
    func interacted(event: StageEvent)
    func menuButtonTapped(button: MenuButton)
}

enum MenuButton {
    case addMoment
    case logMoments
    case nextMoment
}

struct NodeMovementMetrics {
    var id: String
    let nodePosition: NodePosition
}

enum StageEvent {
    case tapped(NodePosition)
    case NodeMoved(NodeMovementMetrics)
}

class StageView: UIView {
    
    static let shared = StageView()
    
    weak var delegate: StageViewDelegate?
    
    var nodes = [NodeView]()
    
    init() { super.init(frame: .zero)
        
        backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)
 
        
        
        let titles = ["add moment", "log moments", "next moment"]
        let buttons = [UIButton(), UIButton(), UIButton()]
        
        for (n,c) in buttons.enumerated() {
            c.tag = n
            c.setTitleColor(.black, for: .normal)
            c.setTitle(titles[n], for: .normal)
            c.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            c.backgroundColor = UIColor(colorLiteralRed: Float(Double(n) * 0.3), green: 1, blue: Float(Double(n) * 0.3), alpha: 1)
        }
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.spacing = 5
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    
    func buttonTapped(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            delegate?.menuButtonTapped(button: .addMoment)
        case 1:
            delegate?.menuButtonTapped(button: .logMoments)
        case 2:
            delegate?.menuButtonTapped(button: .nextMoment)
        default: break
        }
        
    }
    
    
    func tapped(rec: UITapGestureRecognizer) {
        
        let nodePosition = rec.location(in: self).nodePosition(inSize: self.bounds.size)
        let tap: StageEvent = .tapped(nodePosition)
        delegate?.interacted(event: tap)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    func addNode(id: String) {
        
        let nodeView = NodeView(id: id)
        
        self.nodes.append(nodeView)
        self.addSubview(nodeView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned))
        nodeView.addGestureRecognizer(pan)
    }
    
    func update(with nodes: [Node]) {
        for node in nodes { getNodeView(id: node.id)?.configure(with: node) }
    }
    
    func getNodeView(id: String) -> NodeView? { return (self.nodes.filter { $0.id == id }).first }
    
    func panned(recognizer: UIPanGestureRecognizer) {
        
        if let node = recognizer.view as? NodeView {
            
            let point = recognizer.location(in: self)
            recognizer.view?.center = point
            
            let nodePosition = point.nodePosition(inSize: self.bounds.size)
            
            let event = StageEvent.NodeMoved(NodeMovementMetrics(id: node.id, nodePosition: nodePosition))
            
            delegate?.interacted(event: event)
        }
    }
}

