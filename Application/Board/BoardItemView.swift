import UIKit

class BoardItemView:UIControl {
    weak var left:NSLayoutConstraint!
    weak var top:NSLayoutConstraint!
    weak var width:NSLayoutConstraint!
    weak var height:NSLayoutConstraint!
    var position:CGPoint { get { return CGPoint(x:self.left.constant, y:self.top.constant) } }
    
    init() {
        super.init(frame:CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
    }
    
    required init?(coder:NSCoder) { return nil }
    override var isSelected:Bool { didSet { self.updateState() } }
    override var isHighlighted:Bool { didSet { self.updateState() } }
    
    private func updateState() {
        if self.isSelected || self.isHighlighted {
            self.alpha = Constants.selected
        } else {
            self.alpha = Constants.notSelected
        }
    }
}

private struct Constants {
    static let selected:CGFloat = 0.2
    static let notSelected:CGFloat = 1.0
}
