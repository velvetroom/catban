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
    
    func set(text:NSAttributedString) {
        let label:UILabel = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.attributedText = text
        
        self.addSubview(label)
        label.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo:self.rightAnchor).isActive = true
    }
    
    func set(image:UIImage) {
        let imageView:UIImageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.bottomLeft
        imageView.image = image
        
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo:self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo:self.rightAnchor).isActive = true
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
