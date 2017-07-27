//
//  MainViewController.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/26/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    static var orbIdentifierCount = 0
    
    let engine = ABAudioEngine()
    
    var orbs = [String: Orb]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine.run()
        
        
        addOrb()
        
    
        
    }
    
    
    
    func panned(rec: UIPanGestureRecognizer) {
        
        let recPoint = rec.location(in: self.view)
        let pannedView = rec.view
        pannedView?.center = recPoint
        
        let freqFromPosition = recPoint.x / self.view.frame.size.width * 2000

        if let nodeView = pannedView as? NodeView {
            
            if let orb = self.orbs[nodeView.orbIdentifier] {
                
                print("freqfrompos: \(freqFromPosition)")
                print("orb freq: \(orb.frequency)")
                
                print("here \n")
                if abs(Double(freqFromPosition) - orb.frequency) > 10.0 {
                print("there")
                    self.engine.setFrequency(node: orb.node, value: Double(freqFromPosition))
                }
                
                orb.frequency = Double(freqFromPosition)
                
                
            }
        }
    }
    
    func addOrb() {
        
        engine.addSinGenerator { newNode in
            
            let nodeView = NodeView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
            
            let orbIdentifier = String(MainViewController.orbIdentifierCount)
            MainViewController.orbIdentifierCount += 1
            
            let orb = Orb(identifier: orbIdentifier, view: nodeView, node: newNode, frequency: 0.0)
            
            nodeView.orbIdentifier = orbIdentifier
            
            self.orbs[nodeView.orbIdentifier] = orb
            

            self.view.addSubview(orb.view)
            
            let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panned))
            orb.view.addGestureRecognizer(pan)

        }
        
    }
    
}


class Orb {
    
    let identifier: String
    let view: NodeView
    let node: SoundNode
    var frequency: Double
    
    init(identifier: String, view: NodeView, node: SoundNode, frequency: Double) {
        self.identifier = identifier
        self.view = view
        self.node = node
        self.frequency = frequency
    }
}


class NodeView: UIView {
    
 
    var orbIdentifier: String!
    
    override init(frame: CGRect) {
        

        super.init(frame: frame)
        
        
        self.backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
