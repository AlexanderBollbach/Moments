//
//  Loggables.swift
//  Orbs
//
//  Created by Alexander Bollbach on 7/28/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import Foundation

extension ToneNode: CustomStringConvertible {
    
    var description: String {
        return "frequency: \(self.frequency) \nvolume: \(self.volume)"
    }
}
