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
        point = .zero
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        makeOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    override var isSelected:Bool { didSet { updateState() } }
    override var isHighlighted:Bool { didSet { updateState() } }
    func makeOutlets() { }
    func showSelected() { }
    func showDefault() { }
    
    func dragStart() {
        isSelected = true
        point = CGPoint(x:left.constant, y:top.constant)
    }
    
    func dragEnd() {
        isSelected = false
    }
    
    func drag(point:CGPoint) {
        left.constant = self.point.x + point.x
        top.constant = self.point.y + point.y
    }
    
    func updateState() {
        if isSelected || isHighlighted {
            showSelected()
        } else {
            showDefault()
        }
    }
    
    func add(target:BoardPresenter, selector:Selector) {
        addTarget(target, action:selector, for:.touchUpInside)
    }
}
