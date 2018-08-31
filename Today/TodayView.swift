import UIKit
import NotificationCenter

@objc(TodayView) class TodayView:UIViewController, NCWidgetProviding {
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
        var left = view.leftAnchor
        today.items.forEach { item in
            let cell = LibraryCellView()
            cell.translatesAutoresizingMaskIntoConstraints = false
            cell.viewModel = item
            view.addSubview(cell)
            cell.leftAnchor.constraint(equalTo:left).isActive = true
            cell.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
            cell.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
            cell.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.25).isActive = true
            left = cell.rightAnchor
        }
    }
    
    @objc private func selector() {
        extensionContext?.open(URL(string:"catban:board?identifier=asd")!, completionHandler:nil)
    }
}
