//
//  MomentsCoordinator.swift
//  Orbs
//
//  Created by Alexander Bollbach on 7/28/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import Foundation

class MomentsCoordinator {
    
    var momentIndex = 0

    var moments = [Moment]()
    
    func addMoment(nodes: [Node]) {
        let newMoment = Moment(nodes: nodes)
        moments.append(newMoment)
        
        Logger.log(moments, message: "added a new moment")
        
    }
    
    func logMoments() { Logger.log(moments, message: "Moments: ") }
    
    func nextMoment() -> Moment {
        let index = momentIndex
        momentIndex += 1
        if momentIndex > moments.count - 1 { momentIndex = 0 }
        return moments[index]
    }
}

struct Moment {
    let nodes: [Node]
}

extension Moment: CustomStringConvertible {
    
    var description: String {
        return "nodes: \(nodes) \n\n"
    }
}



