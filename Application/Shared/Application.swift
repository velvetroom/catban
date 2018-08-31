import UIKit
import Catban
import Firebase

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    static let router = Router()
    var window:UIWindow?
    
    func application(_:UIApplication, didFinishLaunchingWithOptions options:[UIApplication.LaunchOptionsKey:
        Any]?) -> Bool {
        injection()
        services()
        makeWindow()
        var launched = false
        if let url = options?[.url] as? URL { urlLaunch(url:url) }
        else if let shortcut = options?[.shortcutItem] as? UIApplicationShortcutItem { }
        else {
            Application.router.launchDefault()
            launched = true
        }
        return launched
    }
    
    func application(_:UIApplication, performActionFor item:UIApplicationShortcutItem,
                     completionHandler:@escaping(Bool) -> Void) {
        if let identifier = item.userInfo?["board"] as? String {
            
        }
    }
    
    func application(_:UIApplication, open url:URL, options:[UIApplication.OpenURLOptionsKey:Any] = [:]) -> Bool {
        if let identifier = board(url:url) {
            Application.router.quick(board:identifier)
            return true
        }
        return false
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
    
    private func urlLaunch(url:URL) {
        if let identifier = board(url:url) {
            Application.router.launch(board:identifier)
        } else {
            Application.router.launchDefault()
        }
    }
    /*
    private func quickLaunch(item:Any?) -> Bool {
        if let board = (item as? UIApplicationShortcutItem)?.userInfo?["board"] as? String {
            Application.router.quick(board:board)
            return false
        } else {
            
            return true
        }
    }
    */
    private func board(url:URL) -> String? {
        var board:String?
        let components = url.absoluteString.components(separatedBy:"catban:board=")
        if components.count == 2 { board = components[1] }
        return board
    }
}
