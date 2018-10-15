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
        shortcut(item:item)
    }
    
    func application(_:UIApplication, open url:URL, options:[UIApplication.OpenURLOptionsKey:Any] = [:]) -> Bool {
        if let board = try? boardFrom(url:url) {
            Application.navigation.quick(board:board)
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
    
    private func shortcut(item:UIApplicationShortcutItem) {
        switch item.type {
        case "catban.addBoard": Application.navigation.quickAdd()
        case "catban.loadBoard": Application.navigation.quickScan()
        default: break
        }
    }
    
    private func launch(options:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        var needsLaunch = false
        if let url = options?[.url] as? URL,
            let board = try? boardFrom(url:url) {
            Application.navigation.launch(board:board)
        } else {
            Application.navigation.launchDefault()
            if let item = options?[.shortcutItem] as? UIApplicationShortcutItem {
                shortcut(item:item)
            } else { needsLaunch = true }
        }
        return needsLaunch
    }
    
    private func boardFrom(url:URL) throws -> String {
        let components = url.absoluteString.components(separatedBy:"catban:board=")
        if components.count == 2,
            !components[1].isEmpty {
            return components[1]
        }
        throw Exception.invalidId
    }
}
