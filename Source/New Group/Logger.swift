//
//  Loggables.swift
//  Orbs
//
//  Created by Alexander Bollbach on 7/28/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import Foundation


struct Logger {
    static func log(_ item: CustomStringConvertible, message: String = "") {
        var logMessage = "\n-------\n" + message
        logMessage += "\n\n" + item.description + "\n----------\n\n"
        print(logMessage)
    }
}

