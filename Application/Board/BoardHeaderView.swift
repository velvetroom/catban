import UIKit

class BoardHeaderView:BoardItemView {
    private(set) weak var label:UILabel!
    
    override func makeOutlets() {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize:25, weight:.bold)
        addSubview(label)
        self.label = label
        
        label.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    override func showSelected() {
        label.textColor = .catBlue
    }
    
    override func showDefault() {
        label.textColor = .black
    }
}
