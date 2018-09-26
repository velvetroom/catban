import UIKit

class BoardCardView:BoardItemView {
    private(set) weak var label:UILabel!
    private(set) weak var dragGesture:UIPanGestureRecognizer!
    private(set) weak var longGesture:UILongPressGestureRecognizer!
    private weak var halo:UIView!
    
    func complete() {
        halo.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.0431372549, blue: 0.1215686275, alpha: 1)
        UIView.animate(withDuration:0.3, animations: { [weak self] in
            self?.halo.alpha = 1
        }) { _ in
            UIView.animate(withDuration:1, animations: { [weak self] in
                self?.halo.alpha = 0
            }) { [weak self] _ in
                self?.halo.backgroundColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
            }
        }
    }
    
    override func makeOutlets() {
        let halo = UIView()
        halo.isUserInteractionEnabled = false
        halo.translatesAutoresizingMaskIntoConstraints = false
        halo.backgroundColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        halo.layer.cornerRadius = 6
        halo.alpha = 0
        addSubview(halo)
        self.halo = halo
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.shadowOffset = CGSize(width:0.5, height:0.5)
        label.shadowColor = .clear
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
            self?.label.shadowColor = UIColor(white:0, alpha:0.3)
        }
    }
    
    override func showDefault() {
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.halo.alpha = 0
            self?.label.shadowColor = .clear
        }
    }
}
