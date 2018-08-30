import UIKit
import NotificationCenter

@objc(TodayView)
class TodayView:UIViewController, NCWidgetProviding {
    weak var scroll:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOutlets()
    }
        
    func widgetPerformUpdate(completionHandler:(@escaping(NCUpdateResult) -> Void)) {
        
    }
    
    private func makeOutlets() {
        self.scroll?.removeFromSuperview()
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceHorizontal = true
        scroll.showsHorizontalScrollIndicator = true
        view.addSubview(scroll)
        self.scroll = scroll
        scroll.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        var x:CGFloat = 0
        /*library.boards.forEach { item in
            let cell = TodayCellView()
            cell.label.text = item.value.text
            cell.frame = CGRect(x:x, y:0, width:100, height:view.bounds.height)
            x += cell.frame.width
            scroll.addSubview(cell)
        }
        */
        let button:UIButton = UIButton()
        button.backgroundColor = .blue
        button.addTarget(self, action:#selector(selector), for:.touchUpInside)
        button.frame = CGRect(x:0, y:0, width:50, height:50)
        scroll.addSubview(button)
    }
    
    @objc private func selector() {
        extensionContext?.open(URL(string:"catban:board?identifier=asd")!, completionHandler:nil)
    }
}
