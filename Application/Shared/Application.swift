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
        return launch(options:options)
    }
    
    func application(_:UIApplication, performActionFor item:UIApplicationShortcutItem,
                     completionHandler:@escaping(Bool) -> Void) {
        switch item.type {
        case "catban.addBoard": Application.router.quickAdd()
        case "catban.loadBoard": Application.router.quickScan()
        default: break
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
    
    private func launch(options:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        var needsLaunch = false
        if let url = options?[.url] as? URL { urlLaunch(url:url) }
        else {
            Application.router.launchDefault()
            if let shortcut = options?[.shortcutItem] as? UIApplicationShortcutItem {
                switch shortcut.type {
                case "catban.addBoard": Application.router.launchAdd()
                case "catban.loadBoard": Application.router.launchScan()
                default: break
                }
            } else { needsLaunch = true }
        }
        return needsLaunch
    }
 
    private func urlLaunch(url:URL) {
        if let identifier = board(url:url) {
            Application.router.launch(board:identifier)
        } else {
            Application.router.launchDefault()
        }
    }
    
    private func board(url:URL) -> String? {
        var board:String?
        let components = url.absoluteString.components(separatedBy:"catban:board=")
        if components.count == 2 { board = components[1] }
        return board
    }
}
