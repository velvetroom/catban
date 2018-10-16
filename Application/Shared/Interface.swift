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
    private(set) var cell:UIColor!
    private(set) var tint:UIColor!
    private(set) var text:UIColor!
    private(set) var scroll:UIScrollView.IndicatorStyle!
    private(set) var status:UIStatusBarStyle!
    private let store = UserDefaults(suiteName:"group.Catban")!
    
    init() {
        if let rawSkin = store.string(forKey:"skin"),
            let skin = Skin(rawValue:rawSkin) {
            self.skin = skin
        } else {
            self.skin = .light
        }
        update()
    }
    
    private func light() {
        background = .white
        cell = .white
        tint = .black
        text = .black
        scroll = .black
        status = .default
    }
    
    private func dark() {
        background = .black
        cell = .catDark
        tint = .white
        text = .white
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
