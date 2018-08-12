import UIKit

class BoardButtonView:BoardItemView {
    weak var image:UIImageView!
    
    override func makeOutlets() {
        super.makeOutlets()
        
        let image:UIImageView = UIImageView()
        image.isUserInteractionEnabled = false
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = UIView.ContentMode.bottomLeft
        self.image = image
        self.addSubview(image)
    }
    
    override func layoutOutlets() {
        super.layoutOutlets()
        
        self.image.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        self.image.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        self.image.leftAnchor.constraint(equalTo:self.leftAnchor).isActive = true
        self.image.rightAnchor.constraint(equalTo:self.rightAnchor).isActive = true
    }
    
    override func showSelected() {
        super.showSelected()
        self.alpha = 0.15
    }
    
    override func showDefault() {
        super.showDefault()
        self.alpha = 1.0
    }
}
