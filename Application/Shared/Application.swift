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
        return quickLaunch(item:options?[.shortcutItem])
    }
    
    func application(_:UIApplication, performActionFor item:UIApplicationShortcutItem,
                     completionHandler:@escaping(Bool) -> Void) {
        guard
            let identifier = item.userInfo?["board"] as? String,
            let view = Application.router.viewControllers.first as? LibraryView
        else { return completionHandler(false) }
        Application.router.dismiss(animated:false)
        Application.router.popToViewController(view, animated:false)
        view.presenter.interactor.select(identifier:identifier)
        completionHandler(true)
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
    
    private func quickLaunch(item:Any?) -> Bool {
        if let board = (item as? UIApplicationShortcutItem)?.userInfo?["board"] as? String {
            Application.router.quick(board:board)
            return false
        } else {
            Application.router.regular()
            return true
        }
    }
}
