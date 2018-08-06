import UIKit

class BoardNewColumnView:BoardItemView {
    weak var image:UIImageView!
    
    override func makeOutlets() {
        super.makeOutlets()
        let image:UIImageView = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = false
        image.clipsToBounds = true
        image.contentMode = UIView.ContentMode.bottomLeft
        image.image = #imageLiteral(resourceName: "assetNewColumn.pdf")
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
}
