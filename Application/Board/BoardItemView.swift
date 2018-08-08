import UIKit
import Domain

class BoardItemView:UIControl {
    weak var halo:UIView!
    weak var left:NSLayoutConstraint!
    weak var top:NSLayoutConstraint!
    weak var width:NSLayoutConstraint!
    weak var height:NSLayoutConstraint!
    weak var label:UILabel!
    weak var image:UIImageView!
    weak var up:BoardItemView?
    weak var down:BoardItemView?
    weak var right:BoardItemView?
    var card:Card!
    var column:Column!
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
    
    func dragStart() {
        self.isSelected = true
        self.halo.isHidden = false
        self.point = CGPoint(x:self.left.constant, y:self.top.constant)
    }
    
    func dragEnd() {
        self.isSelected = false
        self.halo.isHidden = true
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
        let halo:UIView = UIView()
        halo.isUserInteractionEnabled = false
        halo.translatesAutoresizingMaskIntoConstraints = false
        halo.backgroundColor = Colors.navyBlue
        halo.layer.cornerRadius = Constants.radius
        halo.isHidden = true
        self.halo = halo
        self.addSubview(halo)
        
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
        self.halo.topAnchor.constraint(equalTo:self.topAnchor, constant:-Constants.halo).isActive = true
        self.halo.leftAnchor.constraint(equalTo:self.leftAnchor, constant:-Constants.halo).isActive = true
        self.halo.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant:Constants.halo).isActive = true
        self.halo.rightAnchor.constraint(equalTo:self.rightAnchor, constant:Constants.halo).isActive = true
        
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
    static let halo:CGFloat = 12.0
    static let radius:CGFloat = 4.0
    static let selected:CGFloat = 0.3
    static let notSelected:CGFloat = 1.0
}
