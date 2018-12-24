import Foundation

struct Logger {
    static func log(_ item: CustomStringConvertible, message: String = "") {
        var logMessage = "\n-------\n" + message
        logMessage += "\n\n" + item.description + "\n----------\n\n"
        print(logMessage)
    }
}

