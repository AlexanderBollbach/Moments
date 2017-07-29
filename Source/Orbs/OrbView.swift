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
        
        translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .red
    }
    
    func configure(with config: OrbViewConfig) {
        
        guard let sv = superview else { return }
 
        let size = config.size.sizeInPoints
        
        frame.size = CGSize(width: sv.frame.size.width * size,
                            height: sv.frame.size.height * size)
        
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
        let orbY = Double(self.y / inSize.height)
        return OrbPosition(x: orbX, y: orbY)
    }
}



