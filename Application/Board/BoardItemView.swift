import UIKit
import Domain

class BoardItemView:UIControl {
    weak var left:NSLayoutConstraint!
    weak var top:NSLayoutConstraint!
    weak var width:NSLayoutConstraint!
    weak var height:NSLayoutConstraint!
    weak var card:Card!
    weak var column:Column!
    weak var label:UILabel!
    weak var image:UIImageView!
    weak var down:BoardItemView?
    weak var right:BoardItemView?
    var point:CGPoint
    
    init() {
        self.point = CGPoint.zero
        super.init(frame:CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.makeOutlets()
        self.layoutOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    override var isSelected:Bool { didSet { self.updateState() } }
    override var isHighlighted:Bool { didSet { self.updateState() } }
    
    func dragStart() {
        self.isSelected = true
        self.point = CGPoint(x:self.left.constant, y:self.top.constant)
    }
    
    func dragEnd() {
        self.isSelected = false
        self.left.constant = self.point.x
        self.top.constant = self.point.y
    }
    
    func drag(point:CGPoint) {
        self.left.constant = self.point.x + point.x
        self.top.constant = self.point.y + point.y
    }
    
    private func updateState() {
        if self.isSelected || self.isHighlighted {
            self.alpha = Constants.selected
        } else {
            self.alpha = Constants.notSelected
        }
    }
    
    private func makeOutlets() {
        let image:UIImageView = UIImageView()
        image.isUserInteractionEnabled = false
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = UIView.ContentMode.bottomLeft
        self.image = image
        self.addSubview(image)
        
        let label:UILabel = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 0
        self.label = label
        self.addSubview(label)
    }
    
    private func layoutOutlets() {
        self.image.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        self.image.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        self.image.leftAnchor.constraint(equalTo:self.leftAnchor).isActive = true
        self.image.rightAnchor.constraint(equalTo:self.rightAnchor).isActive = true
        
        self.label.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        self.label.leftAnchor.constraint(equalTo:self.leftAnchor).isActive = true
        self.label.rightAnchor.constraint(equalTo:self.rightAnchor).isActive = true
    }
}

private struct Constants {
    static let selected:CGFloat = 0.2
    static let notSelected:CGFloat = 1.0
}
