import UIKit

class Interface {
    var skin:Skin {
        didSet {
            store.set(skin.rawValue, forKey:"skin")
            store.synchronize()
            update()
        }
    }
    private(set) var background:UIColor!
    private(set) var over:UIColor!
    private(set) var tint:UIColor!
    private(set) var text:UIColor!
    private(set) var keyboard:UIKeyboardAppearance!
    private(set) var bar:UIBarStyle!
    private(set) var scroll:UIScrollView.IndicatorStyle!
    private(set) var status:UIStatusBarStyle!
    private let store = UserDefaults(suiteName:"group.Catban")!
    
    init() {
        if let rawSkin = store.string(forKey:"skin"),
            let skin = Skin(rawValue:rawSkin) {
            self.skin = skin
        } else {
            self.skin = .dark
        }
        update()
    }
    
    private func light() {
        background = .white
        over = .catLight
        tint = .black
        text = .black
        keyboard = .default
        bar = .default
        scroll = .black
        status = .default
    }
    
    private func dark() {
        background = .black
        over = .catDark
        tint = .white
        text = .white
        keyboard = .dark
        bar = .black
        scroll = .white
        status = .lightContent
    }
    
    private func update() {
        switch skin {
        case .light: light()
        case .dark: dark()
        }
    }
}
