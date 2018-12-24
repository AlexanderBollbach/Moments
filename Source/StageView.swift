import UIKit

struct ViewMovement {
    let id: String
    let position: NodePosition
}

enum StageEvent {
    case moved(ViewMovement)
    case tapped(NodePosition)
}

protocol StageViewDelegate: class {
    func interacted(event: StageEvent)
    func menuButtonTapped(button: MenuButton)
}

enum MenuButton {
    case addMoment
    case logMoments
    case nextMoment
    case clear
}

class StageView: UIView {
    
    //    static let shared = StageView()
    weak var delegate: StageViewDelegate?
    
    var nodes = [NodeView]()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        configureControls()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func add(id: String) -> NodeView {
        
        let nodeView = NodeView(id: id)
        
        nodes.append(nodeView)
        addSubview(nodeView)
        
        nodeView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panned)))
        
        return nodeView
    }
    
    func update(with metrics: [NodeViewMetrics]) {
        
        // pre remove missing metrics
        for node in nodes {
            if !metrics.contains(where: { $0.id == node.id }) {
                remove(id: node.id)
            }
        }
        
        
        // pre add missing nodes
        for m in metrics {
            if !nodes.contains(where: { node in node.id == m.id }) {
                _ = add(id: m.id)
            }
        }
        
        // add in new ones
        
        
        
        metrics.forEach {
            let node = getNodeView(id: $0.id)
            node?.configure(with: $0)
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
        
        let viewMovement = ViewMovement(id: node.id, position: point.nodePosition(inSize: self.bounds.size))
        
        delegate?.interacted(event: StageEvent.moved(viewMovement))
    }
    
    // HELPERS
    
    func remove(id: String) {
        guard let index = self.nodes.index(where: { $0.id == id }) else { return }
        let node = self.nodes[index]
        node.removeFromSuperview()
        self.nodes.remove(at: index)
    }
    
    private func configureControls() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)
        
        
        let titles = ["add moment", "log moments", "next moment", "clear"]
        let buttons = [UIButton(), UIButton(), UIButton(), UIButton()]
        
        for (n, c) in buttons.enumerated() {
            c.tag = n
            c.setTitleColor(UIColor.white, for: .highlighted)
            c.setTitleColor(.black, for: .normal)
            c.setTitle(titles[n], for: .normal)
            c.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            c.backgroundColor = UIColor(
                colorLiteralRed: Float(Double(n) * 0.5),
                green: 0.2,
                blue: Float(Double(n) * 0.3),
                alpha: 1
            )
        }
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.spacing = 5
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sv.heightAnchor.constraint(equalToConstant: 75).isActive = true
        sv.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func buttonTapped(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            delegate?.menuButtonTapped(button: .addMoment)
        case 1:
            delegate?.menuButtonTapped(button: .logMoments)
        case 2:
            delegate?.menuButtonTapped(button: .nextMoment)
        case 3:
            delegate?.menuButtonTapped(button: .clear)
        default: break
        }
        
    }
    
    func tapped(rec: UITapGestureRecognizer) {
        let nodePosition = rec.location(in: self).nodePosition(inSize: self.bounds.size)
        let tap: StageEvent = .tapped(nodePosition)
        delegate?.interacted(event: tap)
    }
}

