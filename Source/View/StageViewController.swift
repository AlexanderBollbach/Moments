//
//  MainViewController.swift
//  AUTest3
//
//  Created by Alexander Bollbach on 7/26/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import UIKit

class StageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let stageView = StageView.shared
        view.addSubview(stageView)
        
        stageView.translatesAutoresizingMaskIntoConstraints = false
        stageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        stageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        stageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        stageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        stageView.delegate = Stage.shared
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Stage.shared.run()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(view.subviews)
    }

}






