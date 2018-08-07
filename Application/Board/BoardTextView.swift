import UIKit
import Domain

class BoardTextView:BoardItemView {
    weak var label:UILabel!
    weak var column:Column!
    
    override init() {
        super.init()
        let label:UILabel = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 0
        self.label = label
        self.addSubview(label)
        label.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo:self.rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
