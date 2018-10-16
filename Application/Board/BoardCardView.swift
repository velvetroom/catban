import UIKit

class BoardCardView:BoardItemView {
    private(set) weak var label:UILabel!
    private(set) weak var dragGesture:UIPanGestureRecognizer!
    private(set) weak var longGesture:UILongPressGestureRecognizer!
    private weak var halo:UIView!
    
    func complete() {
        halo.backgroundColor = .catRed
        UIView.animate(withDuration:0.3, animations: { [weak self] in
            self?.halo.alpha = 1
        }) { _ in
            UIView.animate(withDuration:1, animations: { [weak self] in
                self?.halo.alpha = 0
            }) { [weak self] _ in
                self?.halo.backgroundColor = .catBlue
            }
        }
    }
    
    override func makeOutlets() {
        let halo = UIView()
        halo.isUserInteractionEnabled = false
        halo.translatesAutoresizingMaskIntoConstraints = false
        halo.backgroundColor = .catBlue
        halo.layer.cornerRadius = 6
        halo.alpha = 0
        addSubview(halo)
        self.halo = halo
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Application.interface.text
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
            self?.label.textColor = .black
            self?.label.shadowColor = Application.interface.text.withAlphaComponent(0.3)
        }
    }
    
    override func showDefault() {
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.halo.alpha = 0
            self?.label.textColor = Application.interface.text
            self?.label.shadowColor = .clear
        }
    }
}
