import UIKit

class BoardItemView:UIButton {
    weak var left:NSLayoutConstraint!
    weak var top:NSLayoutConstraint!
    weak var width:NSLayoutConstraint!
    weak var height:NSLayoutConstraint!
    var position:CGPoint { get { return CGPoint(x:self.left.constant, y:self.top.constant) } }
    
    init() {
        super.init(frame:CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.makeOutlets()
        self.layoutOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func makeOutlets() { }
    func layoutOutlets() { }
    func stateHighlighted() { }
    func stateDefault() { }
}
