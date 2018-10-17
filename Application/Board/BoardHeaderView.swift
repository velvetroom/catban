import UIKit

class BoardHeaderView:BoardItemView {
    private(set) weak var label:UILabel!
    
    override func makeOutlets() {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Application.interface.text
        label.font = .systemFont(ofSize:30, weight:.bold)
        label.numberOfLines = 0
        addSubview(label)
        self.label = label
        
        label.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    override func showSelected() {
        alpha = 0.3
    }
    
    override func showDefault() {
        alpha = 1
    }
}
