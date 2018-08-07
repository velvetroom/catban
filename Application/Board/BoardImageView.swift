import UIKit
import Domain

class BoardImageView:BoardItemView {
    weak var imageView:UIImageView!
    weak var column:Column!
    
    override init() {
        super.init()
        let imageView:UIImageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.bottomLeft
        self.imageView = imageView    
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo:self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo:self.rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
