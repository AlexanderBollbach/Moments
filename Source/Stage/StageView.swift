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

struct OrbMovementMetrics {
    
    var id: String
    let orbPosition: OrbPosition
}

enum StageEvent {
    case tapped
    case OrbMoved(OrbMovementMetrics)
}

class StageView: UIView {
    
    static let shared = StageView()
    
    weak var delegate: StageViewDelegate?
    
    var orbs = [OrbView]()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)
        
    }
    
    func tapped(rec: UITapGestureRecognizer) {
        delegate?.interacted(event: .tapped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addOrb(id: String) {
        
        let orbView = OrbView(id: id)
        
        self.orbs.append(orbView)
        
        self.addSubview(orbView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned))
        orbView.addGestureRecognizer(pan)
    }
    
    func update(with orbs: [Orb]) {
        
        for orb in orbs {
            getOrbView(id: orb.id)?.configure(with: orb)
        }
    }
    
    func getOrbView(id: String) -> OrbView? { return (self.orbs.filter { $0.id == id }).first }
    
    func panned(recognizer: UIPanGestureRecognizer) {
        
        if let orb = recognizer.view as? OrbView {
            
            let point = recognizer.location(in: self)
            recognizer.view?.center = point
            
            let orbPosition = point.orbPosition(inSize: self.bounds.size)
            
            let event = StageEvent.OrbMoved(OrbMovementMetrics(id: orb.id, orbPosition: orbPosition))
            
            delegate?.interacted(event: event)
        }
    }
}

