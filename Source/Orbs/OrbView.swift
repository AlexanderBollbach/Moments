//
//  NodeView.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import UIKit



class OrbView: UIView {
    
    let id: String
    
    init(id: String) {
        
        self.id = id
        
        super.init(frame: .zero)
        
        self.backgroundColor = .red
    }
    
    func configure(with config: OrbViewConfig?) {
        
        guard let sv = superview else { return }
        
        guard let config = config else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let size = config.size.sizeInPoints
        
        self.frame.size = CGSize(width: sv.frame.size.width * size, height: sv.frame.size.height * size)
        
        self.center = CGPoint(with: config.position, inSize: sv.frame.size)
    }
    
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension CGPoint {
    
    init(with position: OrbPosition, inSize: CGSize) {
        
        self.x = CGFloat(position.x) * inSize.width
        self.y = CGFloat(position.y) * inSize.height
    }
    
    func orbPosition(inSize: CGSize) -> OrbPosition {
        let orbX = Double(self.x / inSize.width)
        let orbY = Double(self.x / inSize.height)
        return OrbPosition(x: orbX, y: orbY)
    }
}


