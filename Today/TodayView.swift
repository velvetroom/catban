import UIKit
import NotificationCenter

@objc(TodayView) class TodayView:UIViewController, NCWidgetProviding {
    private weak var effect:UIVisualEffectView!
    private weak var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let effect:UIVisualEffectView
        if #available(iOSApplicationExtension 10.0, *) {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.widgetPrimary())
        } else {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.notificationCenter())
        }
        view.addSubview(effect)
        effect.translatesAutoresizingMaskIntoConstraints = false
        effect.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        effect.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        effect.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        effect.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        self.effect = effect
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize:15, weight:.light)
        label.text = "No boards created yet."
        label.textColor = .black
        view.addSubview(label)
        label.topAnchor.constraint(equalTo:view.topAnchor, constant:10).isActive = true
        label.leftAnchor.constraint(equalTo:view.leftAnchor, constant:10).isActive = true
        self.label = label
    }
    
    func widgetPerformUpdate(completionHandler:(@escaping(NCUpdateResult) -> Void)) {
        DispatchQueue.global(qos:.background).async { [weak self] in self?.update(result:completionHandler) }
    }
    
    private func update(result:@escaping((NCUpdateResult) -> Void)) {
        if let today = Today.retrieve() {
            DispatchQueue.main.async { [weak self] in
                self?.makeOutlets(today:today)
                result(.newData)
            }
        } else {
            DispatchQueue.main.async { result(.noData) }
        }
    }
    
    private func makeOutlets(today:Today) {
        if !today.items.isEmpty { label.isHidden = true }
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
}
