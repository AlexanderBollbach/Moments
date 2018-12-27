import UIKit

struct ToneNodeViewMetrics {
    let size: NodeSize
    let position: NodePosition
    let health: NodeHealth
}

enum NodeViewMetricsValues {
    case baseNode
    case toneNode(ToneNodeViewMetrics)
}

struct ViewMetrics {
    let id: String
    let values: NodeViewMetricsValues
}

struct ViewMovement {
    let id: String
    let position: NodePosition
}

class StageView: UIView {
    
    enum Event {
        case movedNode(ViewMovement)
        case tappedBlankSpace(NodePosition)
        case addMoment
        case nextMoment
        case clearMoments
    }
    
    var onEvent: (Event) -> Void = { _ in }
   
    var nodes = [NodeView]()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        
        let cv = ControlsView()
        
        cv.onEvent = { [unowned self] event in
            switch event {
            case .addMoment:
                self.onEvent(.addMoment)
            case .nextMoment:
                self.onEvent(.nextMoment)
            case .clearMoments:
                self.onEvent(.clearMoments)
            }
        }
        
        cv.pinToTop(superView: self, heightMultiplier: 0.2)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func add(id: String) {
        let nodeView = NodeView(id: id)
        nodes.append(nodeView)
        addSubview(nodeView)
        nodeView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panned)))
    }
    
    func update(with metrics: [ViewMetrics]) {
        
        for node in nodes where !metrics.contains(where: { $0.id == node.id }) {
            remove(id: node.id)
        }
        
        for metric in metrics where !nodes.contains(where: { $0.id == metric.id }) {
            add(id: metric.id)
        }
        
        for metric in metrics {
            getNodeView(id: metric.id)?.configure(with: metric)
        }
    }
    
    func flareAll() {
        nodes.forEach { $0.flare() }
    }
    
    func getNodeView(id: String) -> NodeView? {
        return nodes.first(where: { $0.id == id })
    }
    
    func panned(recognizer: UIPanGestureRecognizer) {
        
        guard let node = recognizer.view as? NodeView else { return }
        
        let point = recognizer.location(in: self)
        
        let viewMovement = ViewMovement(
            id: node.id,
            position: point.nodePosition(inSize: self.bounds.size)
        )
        
        onEvent(.movedNode(viewMovement))
    }
    
    private func remove(id: String) {
        guard let index = self.nodes.index(where: { $0.id == id }) else { return }
        let node = self.nodes[index]
        node.removeFromSuperview()
        self.nodes.remove(at: index)
    }
    
    func tapped(rec: UITapGestureRecognizer) {
        onEvent(
            .tappedBlankSpace(rec.location(in: self).nodePosition(inSize: bounds.size))
        )
    }
}

