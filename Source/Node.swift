import UIKit

protocol Node {
    var id: String { get }
    
    var size: NodeSize { get set }
    var position: NodePosition { get set }
    var health: Double { get set }
    
    var targetPosition: NodePosition? { get set }
    var targetHealth: Double? { get set }
    
    var shouldDie: Bool { get set }
}

extension Node {
    
    func isNearTargetPosition() -> Bool {
        guard let targetPos = targetPosition else { return false }
        return abs(targetPos.x - position.x) < 0.001 && abs(targetPos.y - position.y) < 0.001
    }
    
    func isNearTargetHealth() -> Bool {
        guard let targetHealth = targetHealth else { return false }
        return abs(targetHealth - health) < 0.001
    }
}

struct BaseNode: Node {
    
    let id: String

    // view
    var size: NodeSize = .small
    var position = NodePosition(x: 0.5, y: 0.5)
    
    var targetPosition: NodePosition?
    
    var health: Double = 1.0 {
        didSet {
            if health > 1.0 {
                self.health = 1.0
            }
            
            if health < 0.0 {
                self.health = 0.0
            }
        }
    }
    
    var targetHealth: Double?
    
    var shouldDie: Bool = false
}


struct ToneNode: Node {
    
    let id: String

    var size: NodeSize = .small
    var position = NodePosition(x: 0.5, y: 0.5)
    
    init(id: String) {
        self.id = id
    }
    
    var targetPosition: NodePosition?
    
    var health: Double = 1.0 {
        didSet {
            if health > 1.0 {
                self.health = 1.0
            }
            
            if health < 0.0 {
                self.health = 0.0
            }
        }
    }
    
    var targetHealth: Double?
    
    var shouldDie: Bool = false
}

struct NodePosition: Equatable {
    let x: Double
    let y: Double
    
    static let defaultPosition = NodePosition(x: 0.5, y: 0.5)
}

func ==(lhs: NodePosition, rhs: NodePosition) -> Bool {
    return lhs.x == rhs.x  && lhs.y == rhs.y
}

enum NodeSize {
    
    case small
    case medium
    case large
    
    var sizeInPoints: CGFloat {
        switch self {
        case .small:
            return 0.1
        case .medium:
            return 0.2
        case .large:
            return 0.35
        }
    }
}

typealias NodeHealth = Double
