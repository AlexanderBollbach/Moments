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
   
    // 'iterator'ish
    func nextMoment() -> Moment? {
        
        let index = momentIndex
        
        momentIndex += 1
        
        if momentIndex > moments.count - 1 {
            momentIndex = 0
        }
        
        guard index <= moments.count - 1 else {
            return nil
        }
        
        return moments[index]
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



