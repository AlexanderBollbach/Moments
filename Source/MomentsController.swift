import Foundation

struct Moment {
    let nodes: [Node]
}

class MomentsController {
    
    private var momentIndex = 0
    private var moments = [Moment]()
    
    func addMoment(nodes: [Node]) {
        moments.append(Moment(nodes: nodes))
    }
    
    func logMoments() {
        Logger.log(moments, message: "Moments: ")
    }
    
    func nextMoment() -> Moment? {
        
        // simplify
        let index = momentIndex
        momentIndex += 1
        if momentIndex > moments.count - 1 { momentIndex = 0 }
        
        if index <= moments.count - 1 {
            return moments[index]
        }
        
        return nil
    }
    
    func clear() {
        momentIndex = 0
        moments = []
    }
}

extension Moment: CustomStringConvertible {
    
    var description: String {
        return "nodes: \(nodes) \n\n"
    }
}



