import UIKit

class BoardCardView:BoardItemView {
    weak var halo:UIView!
    weak var label:UILabel!
    weak var gesture:UIPanGestureRecognizer!
    
    override func makeOutlets() {
        super.makeOutlets()
        
        let halo:UIView = UIView()
        halo.isUserInteractionEnabled = false
        halo.translatesAutoresizingMaskIntoConstraints = false
        halo.backgroundColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        halo.layer.cornerRadius = Constants.radius
        halo.alpha = 0.0
        self.halo = halo
        self.addSubview(halo)
        
        let label:UILabel = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 0
        self.label = label
        self.addSubview(label)
        
        let gesture:UIPanGestureRecognizer = UIPanGestureRecognizer()
        self.gesture = gesture
        self.addGestureRecognizer(gesture)
    }
    
    override func layoutOutlets() {
        super.layoutOutlets()
        
        self.halo.topAnchor.constraint(equalTo:self.topAnchor, constant:-Constants.halo).isActive = true
        self.halo.leftAnchor.constraint(equalTo:self.leftAnchor, constant:-Constants.halo).isActive = true
        self.halo.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant:Constants.halo).isActive = true
        self.halo.rightAnchor.constraint(equalTo:self.rightAnchor, constant:Constants.halo).isActive = true
        
        self.label.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        self.label.leftAnchor.constraint(equalTo:self.leftAnchor).isActive = true
        self.label.rightAnchor.constraint(equalTo:self.rightAnchor).isActive = true
    }
    
    override func showSelected() {
        super.showSelected()
        UIView.animate(withDuration:Constants.animation) { [weak self] in
            self?.halo.alpha = 1.0
        }
    }
    
    override func showDefault() {
        super.showDefault()
        UIView.animate(withDuration:Constants.animation) { [weak self] in
            self?.halo.alpha = 0.0
        }
    }
}

private struct Constants {
    static let halo:CGFloat = 12.0
    static let radius:CGFloat = 4.0
    static let animation:TimeInterval = 0.3
}
