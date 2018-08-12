import UIKit

class BoardHeaderView:BoardItemView {
    weak var label:UILabel!
    
    override func makeOutlets() {
        super.makeOutlets()
        let label:UILabel = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.bold)
        self.label = label
        self.addSubview(label)
    }
    
    override func layoutOutlets() {
        super.layoutOutlets()
        self.label.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        self.label.leftAnchor.constraint(equalTo:self.leftAnchor).isActive = true
        self.label.rightAnchor.constraint(equalTo:self.rightAnchor).isActive = true
    }
    
    override func showSelected() {
        super.showSelected()
        self.label.textColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
    }
    
    override func showDefault() {
        super.showDefault()
        self.label.textColor = UIColor.black
    }
}

private struct Constants {
    static let font:CGFloat = 18.0
}
