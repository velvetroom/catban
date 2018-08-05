import UIKit

class CanvasItem:UIView {
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
        self.stateDefault()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func makeOutlets() { }
    func layoutOutlets() { }
    func stateHighlighted() { }
    func stateDefault() { }
    func action() { }
    func endMoving() { self.animateChanges() }
    func update(position:CGPoint) { self.animateChanges() }
    
    func stateMoving() {
        self.superview?.bringSubviewToFront(self)
        self.animateChanges()
    }
    
    private func animateChanges() {
        UIView.animate(withDuration:Constants.animation) { [weak self] in
            self?.superview?.layoutIfNeeded()
        }
    }
}

private struct Constants {
    static let animation:TimeInterval = 0.3
}
