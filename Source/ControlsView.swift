import UIKit
import NodeKit

class ControlsView: UIView {
    
    enum Event {
        case addMoment
        case nextMoment
        case clearMoments
    }
    
    var onEvent: (Event) -> Void = { _ in }
    
    init() {
        super.init(frame: .zero)
        
        let nodes: [NodeKit.Node] = [
            NodeKit.Node(
                id: 0,
                isSelected: false,
                type: .setItem1(
                    title: "add",
                    isActive: false,
                    action: {  [unowned self] in self.onEvent(.addMoment) }
                )
                
            ),
            NodeKit.Node(
                id: 1,
                isSelected: false,
                type: .setItem1(
                    title: "next",
                    isActive: false,
                    action: { [unowned self] in self.onEvent(.nextMoment) }
                )
            ),
            NodeKit.Node(
                id: 2,
                isSelected: false,
                type: .setItem1(
                    title: "clear",
                    isActive: false,
                    action: { [unowned self] in self.onEvent(.clearMoments) }
                )
            )
        ]
        
        let combined = NodeKit.Node(
            id: 0,
            isSelected: false,
            type: .set(
                turtles: nodes,
                config: NodeConfig.init(
                    layout: .equalSpacing(axis: .horizontal),
                    supportsSelection: false),
                onSelected: { _, _ in }
            )
        )
        
        let view = render(turtle: combined)
        
        
        view.pinTo(superView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

