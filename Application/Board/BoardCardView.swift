import UIKit

class BoardCardView:BoardItemView {
    weak var halo:UIView!
    weak var label:UILabel!
    weak var dragGesture:UIPanGestureRecognizer!
    weak var longGesture:UILongPressGestureRecognizer!
    
    override func makeOutlets() {
        let halo = UIView()
        halo.isUserInteractionEnabled = false
        halo.translatesAutoresizingMaskIntoConstraints = false
        halo.backgroundColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        halo.layer.cornerRadius = 3
        halo.alpha = 0
        addSubview(halo)
        self.halo = halo
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        addSubview(label)
        self.label = label
        
        let dragGesture = UIPanGestureRecognizer()
        addGestureRecognizer(dragGesture)
        self.dragGesture = dragGesture
        
        let longGesture = UILongPressGestureRecognizer()
        longGesture.minimumPressDuration = 1
        addGestureRecognizer(longGesture)
        self.longGesture = longGesture
        
        halo.topAnchor.constraint(equalTo:topAnchor, constant:-10).isActive = true
        halo.leftAnchor.constraint(equalTo:leftAnchor, constant:-10).isActive = true
        halo.bottomAnchor.constraint(equalTo:bottomAnchor, constant:10).isActive = true
        halo.rightAnchor.constraint(equalTo:rightAnchor, constant:10).isActive = true
        
        label.topAnchor.constraint(equalTo:topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    override func showSelected() {
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.halo.alpha = 1
        }
    }
    
    override func showDefault() {
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.halo.alpha = 0
        }
    }
}
