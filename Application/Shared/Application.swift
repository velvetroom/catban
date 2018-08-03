import UIKit

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    static private(set) var router:Router = Router()
    var window:UIWindow?
    
    func application(_:UIApplication, didFinishLaunchingWithOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        Injection.configure()
        Services.start()
        let window:UIWindow = UIWindow(frame:UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        window.rootViewController = Application.router
        self.window = window
        return true
    }
}
