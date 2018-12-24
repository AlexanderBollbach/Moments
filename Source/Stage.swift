class Stage {
    
    var IDMAker = 0
    
    let audioEngine = AudioController()
    let nodeManager = NodeController()
    let momentsCoordinator = MomentsController()
    
    let stageView: StageView
    
    init(stageView: StageView) {
        self.stageView = stageView
    }
    
    func genID() -> String {
        IDMAker += 1
        return String(IDMAker)
    }
    
    func run() {
        audioEngine.run()
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    @objc private func tick() {
        
        nodeManager.tick()
        
        let viewMetrics = nodeManager.nodeViewMetrics()
        let audioMetrics = nodeManager.nodeAudioMetrics()
        
        stageView.update(with: viewMetrics)
        audioEngine.update(with: audioMetrics)
    }
 
    fileprivate func addNode(at position: NodePosition) {
        nodeManager.addToneNode(
            id: genID(),
            at: position
        )
    }
    
    
    func updateNode(id: String, at position: NodePosition) {
        nodeManager.updatePosition(
            id: id,
            value: position
        )
    }
    
    
    fileprivate func addMoment() {
        momentsCoordinator.addMoment(nodes: nodeManager.allNodes)
        stageView.flareAll()
    }
    
    
    fileprivate func nextMoment() {
        if let nextMoment = momentsCoordinator.nextMoment() {
            apply(moment: nextMoment)
        }
    }
    
    
    fileprivate func clear() {
        nodeManager.clear()
    
        momentsCoordinator.clear()
        
        audioEngine.clear()
    }
    
    private func apply(moment: Moment) {
        nodeManager.apply(moment: moment)
    }
}

extension Stage: StageViewDelegate {
    
    func interacted(event: StageEvent) {
        
        switch event {
        
        case .tapped(let position):
            addNode(at: position)
            
        case .moved(let viewMovement):
            updateNode(id: viewMovement.id, at: viewMovement.position)
        }

    }
    
    func menuButtonTapped(button: MenuButton) {
        
        switch button {
        
        case .addMoment:
            addMoment()
        
        case .logMoments:
            momentsCoordinator.logMoments()
        
        case .nextMoment:
            nextMoment()
        
        case .clear:
            clear()
        }
    }
}
