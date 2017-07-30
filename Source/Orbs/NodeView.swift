//
//  NodeView.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import UIKit



class NodeView: UIView {
    
    let id: String
    
    init(id: String) {
        
        self.id = id
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white
    }
    
    func configure(with metrics: NodeViewMetrics) {
        
        
 
        switch metrics.values {
        case .baseNode:
            break
        case .toneNode(let metrics):
            update(position: metrics.position, size: metrics.size, health: metrics.health)
        }
        
      
    }
    
    
    func update(position: NodePosition, size: NodeSize, health: NodeHealth) {
        
        guard let sv = superview else { return }
        
        frame.size = CGSize(width: sv.frame.size.width * size.sizeInPoints,
                            height: sv.frame.size.height * size.sizeInPoints
        )
        
        self.center = CGPoint(with: position, inSize: sv.frame.size)
        
        self.alpha = CGFloat(health)
    }
    
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    func flare() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = .black
        }) { (true) in
            UIView.animate(withDuration: 0.1, animations: {
                self.backgroundColor = .white
            })
        }
        
    }
}

extension CGPoint {
    
    init(with position: NodePosition, inSize: CGSize) {
        
        self.x = CGFloat(position.x) * inSize.width
        self.y = CGFloat(position.y) * inSize.height
    }
    
    func nodePosition(inSize: CGSize) -> NodePosition {
        let nodeX = Double(self.x / inSize.width)
        let nodeY = Double(self.y / inSize.height)
        return NodePosition(x: nodeX, y: nodeY)
    }
}



