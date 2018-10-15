import UIKit
import NotificationCenter

@objc(TodayView) class TodayView:UIViewController, NCWidgetProviding {
    private weak var effect:UIVisualEffectView!
    private weak var label:UILabel!
    private weak var image:UIImageView!
    private weak var button:UIControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let effect:UIVisualEffectView
        if #available(iOSApplicationExtension 10.0, *) {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.widgetPrimary())
        } else {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.notificationCenter())
        }
        effect.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(effect)
        self.effect = effect
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize:16, weight:.light)
        label.text = NSLocalizedString("TodayView.label", comment:String())
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        effect.contentView.addSubview(label)
        self.label = label
        
        let image = UIImageView(image:#imageLiteral(resourceName: "iconPointer.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        image.isUserInteractionEnabled = false
        image.isHidden = true
        effect.contentView.addSubview(image)
        self.image = image
        
        let button = UIControl()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.addTarget(self, action:#selector(open), for:.touchUpInside)
        button.addTarget(self, action:#selector(highlight), for:.touchDown)
        button.addTarget(self, action:#selector(unhighlight), for:[.touchUpOutside, .touchUpInside, .touchCancel])
        view.addSubview(button)
        self.button = button
        
        effect.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        effect.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        effect.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        effect.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        image.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant:30).isActive = true
        image.heightAnchor.constraint(equalToConstant:30).isActive = true
        image.leftAnchor.constraint(equalTo:label.rightAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        button.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
    }
    
    func widgetPerformUpdate(completionHandler:(@escaping(NCUpdateResult) -> Void)) {
        if let today = Today.retrieve() {
            makeOutlets(today:today)
            completionHandler(.newData)
        } else {
            label.isHidden = false
            image.isHidden = false
            button.isUserInteractionEnabled = true
            completionHandler(.noData)
        }
    }
    
    private func makeOutlets(today:Today) {
        label.isHidden = !today.items.isEmpty
        var left = effect.leftAnchor
        today.items.forEach { item in
            let cell = TodayCellView(item:item)
            effect.contentView.addSubview(cell)
            cell.leftAnchor.constraint(equalTo:left).isActive = true
            cell.topAnchor.constraint(equalTo:effect.topAnchor).isActive = true
            cell.bottomAnchor.constraint(equalTo:effect.bottomAnchor).isActive = true
            cell.widthAnchor.constraint(equalTo:effect.widthAnchor, multiplier:0.25).isActive = true
            left = cell.rightAnchor
            cell.addTarget(cell, action:#selector(cell.highlight), for:.touchDown)
            cell.addTarget(cell, action:#selector(cell.unhighlight), for:[.touchUpOutside,.touchCancel,.touchDragExit])
            cell.addTarget(self, action:#selector(selected(cell:)), for:.touchUpInside)
        }
    }
    
    @objc private func selected(cell:TodayCellView) {
        if let url:URL = URL(string:"catban:board=\(cell.item.board)") {
            extensionContext?.open(url, completionHandler:nil)
        }
    }
    
    @objc private func highlight() { view.alpha = 0.2 }
    @objc private func unhighlight() { view.alpha = 1 }
    
    @objc private func open() {
        extensionContext?.open(URL(string:"catban:")!, completionHandler:nil)
    }
}
