import UIKit
import Catban
import Firebase

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    static let router = Router()
    var window:UIWindow?
    
    func application(_:UIApplication, didFinishLaunchingWithOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        injection()
        services()
        makeWindow()
        return true
    }
    
    private func injection() {
        Factory.cache = Cache.self
        Factory.database = Database.self
    }
    
    private func services() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    private func makeWindow() {
        window = UIWindow(frame:UIScreen.main.bounds)
        window!.backgroundColor = .white
        window!.makeKeyAndVisible()
        window!.rootViewController = Application.router
    }
}
