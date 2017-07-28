//
//  StageView.swift
//  Orbs
//
//  Created by Alexander Bollbach on 7/27/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import UIKit

protocol StageViewDelegate: class {
    func interacted(event: StageEvent)
}

enum StageEvent {
    case tapped
}

class StageView: UIView {
    
    static let shared = StageView()
    
    weak var delegate: StageViewDelegate?
    
    var orbs = [String: OrbView]()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.blue.withAlphaComponent(0.4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.interacted(event: .tapped)
    }
    
    func addOrb(id: String) {
        
        let orbView = OrbView()
        
        self.orbs[id] = orbView
        
        self.addSubview(orbView)
    }
    
    func update(with orbs: [Orb]) {
        
        for orb in orbs {
            getOrbView(id: orb.id)?.configure(with: orb)
        }
    }
    
    func getOrbView(id: String) -> OrbView? { return self.orbs[id] }
}

