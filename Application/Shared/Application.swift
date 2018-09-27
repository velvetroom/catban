import UIKit
import Catban
import Firebase

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    static let navigation = Navigation()
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
        case "catban.addBoard": Application.navigation.quickAdd()
        case "catban.loadBoard": Application.navigation.quickScan()
        default: break
        }
    }
    
    func application(_:UIApplication, open url:URL, options:[UIApplication.OpenURLOptionsKey:Any] = [:]) -> Bool {
        if let identifier = board(url:url) {
            Application.navigation.quick(board:identifier)
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
        window!.rootViewController = Application.navigation
    }
    
    private func launch(options:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        var needsLaunch = false
        if let url = options?[.url] as? URL,
            let identifier = board(url:url) {
            Application.navigation.launch(board:identifier)
        } else {
            Application.navigation.launchDefault()
            if let shortcut = options?[.shortcutItem] as? UIApplicationShortcutItem {
                switch shortcut.type {
                case "catban.addBoard": Application.navigation.launchAdd()
                case "catban.loadBoard": Application.navigation.launchScan()
                default: break
                }
            } else { needsLaunch = true }
        }
        return needsLaunch
    }
    
    private func board(url:URL) -> String? {
        var board:String?
        let components = url.absoluteString.components(separatedBy:"catban:board=")
        if components.count == 2 { board = components[1] }
        return board
    }
}
