import UIKit

class BoardCardView:BoardItemView {
    weak var halo:UIView!
    weak var label:UILabel!
    weak var gesture:UIPanGestureRecognizer!
    private static let halo:CGFloat = 12
    
    override func makeOutlets() {
        let halo = UIView()
        halo.isUserInteractionEnabled = false
        halo.translatesAutoresizingMaskIntoConstraints = false
        halo.backgroundColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        halo.layer.cornerRadius = 4
        halo.alpha = 0.0
        addSubview(halo)
        self.halo = halo
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        addSubview(label)
        self.label = label
        
        let gesture = UIPanGestureRecognizer()
        addGestureRecognizer(gesture)
        self.gesture = gesture
        
        halo.topAnchor.constraint(equalTo:topAnchor, constant:-BoardCardView.halo).isActive = true
        halo.leftAnchor.constraint(equalTo:leftAnchor, constant:-BoardCardView.halo).isActive = true
        halo.bottomAnchor.constraint(equalTo:bottomAnchor, constant:BoardCardView.halo).isActive = true
        halo.rightAnchor.constraint(equalTo:rightAnchor, constant:BoardCardView.halo).isActive = true
        
        label.topAnchor.constraint(equalTo:topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    override func showSelected() {
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.halo.alpha = 1.0
        }
    }
    
    override func showDefault() {
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.halo.alpha = 0.0
        }
    }
}
