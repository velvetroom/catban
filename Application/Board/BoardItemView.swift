import UIKit
import Catban

class BoardItemView:UIControl {
    weak var left:NSLayoutConstraint!
    weak var top:NSLayoutConstraint!
    weak var width:NSLayoutConstraint!
    weak var height:NSLayoutConstraint!
    weak var up:BoardItemView?
    weak var down:BoardItemView?
    weak var right:BoardItemView?
    var column:Column!
    var card:Card!
    var point:CGPoint
    
    init() {
        self.point = CGPoint.zero
        super.init(frame:CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.makeOutlets()
        self.layoutOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    override var isSelected:Bool { didSet { self.updateState() } }
    override var isHighlighted:Bool { didSet { self.updateState() } }
    func makeOutlets() { }
    func layoutOutlets() { }
    func showSelected() { }
    func showDefault() { }
    
    final func dragStart() {
        self.isSelected = true
        self.point = CGPoint(x:self.left.constant, y:self.top.constant)
    }
    
    final func dragEnd() {
        self.isSelected = false
    }
    
    final func drag(point:CGPoint) {
        self.left.constant = self.point.x + point.x
        self.top.constant = self.point.y + point.y
    }
    
    final func updateState() {
        if self.isSelected || self.isHighlighted {
            self.showSelected()
        } else {
            self.showDefault()
        }
    }
    
    final func add(target:BoardPresenter, selector:Selector) {
        self.addTarget(target, action:selector, for:UIControl.Event.touchUpInside)
    }
}
