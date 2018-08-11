import UIKit
import Catban
import Firebase

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    static private(set) var router:Router = Router()
    var window:UIWindow?
    
    func application(_:UIApplication, didFinishLaunchingWithOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        self.injection()
        self.services()
        self.makeWindow()
        return true
    }
    
    private func injection() {
        Configuration.cache = Cache.self
        Configuration.database = Database.self
    }
    
    private func services() {
        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
        FirebaseApp.configure()
    }
    
    private func makeWindow() {
        let window:UIWindow = UIWindow(frame:UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        window.rootViewController = Application.router
        self.window = window
    }
}
