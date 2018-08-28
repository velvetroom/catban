import UIKit

class BoardHeaderView:BoardItemView {
    weak var label:UILabel!
    
    override func makeOutlets() {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize:25, weight:.bold)
        addSubview(label)
        self.label = label
        
        label.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    override func showSelected() {
        label.textColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
    }
    
    override func showDefault() {
        label.textColor = .black
    }
}
