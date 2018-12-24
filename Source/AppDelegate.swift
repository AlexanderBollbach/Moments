import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = StageViewController.init()
        window?.makeKeyAndVisible()
        return true
    }
}

class StageViewController: UIViewController {
    
    lazy var stage: Stage = { Stage.init(stageView: self.stageView) }()
    
    let stageView = StageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stageView)
        
        stageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            stageView.topAnchor.constraint(equalTo: view.topAnchor),
            stageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        stageView.delegate = stage
        
        stage.run()
    }
}
