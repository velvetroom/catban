import UIKit

class BoardButtonView:BoardItemView {
    private(set) weak var image:UIImageView!
    
    override func makeOutlets() {
        let image = UIImageView()
        image.isUserInteractionEnabled = false
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .bottomLeft
        image.tintColor = Application.interface.tint
        addSubview(image)
        self.image = image
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    override func showSelected() {
        alpha = 0.3
    }
    
    override func showDefault() {
        alpha = 1
    }
}
