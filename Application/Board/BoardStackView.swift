import UIKit

class BoardStackView:UIView {
    private var itemX:CGFloat
    private var itemY:CGFloat
    private var width:CGFloat
    private var height:CGFloat = 0
    private static let width:CGFloat = 35
    private static let height:CGFloat = 3
    private static let spacing:CGFloat = 10
    
    init() {
        itemX = 0
        itemY = 0
        width = 0
        height = 0
        super.init(frame:.zero)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { return CGSize(width:width, height:height) }
    
    func update(progress:BoardProgress) {
        subviews.forEach { (item) in item.removeFromSuperview() }
        width = 0
        height = 0
        itemX = 0
        progress.columns.forEach { (items) in
            itemY = 0
            if !subviews.isEmpty {
                itemX += BoardStackView.spacing
            }
            addItem(color:#colorLiteral(red: 0.9229999781, green: 0.201000005, blue: 0.3190000057, alpha: 1))
            for _ in 0 ..< items {
                addItem(color:#colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1))
            }
            itemX += BoardStackView.width
            height = max(height, itemY)
        }
        width = itemX
        invalidateIntrinsicContentSize()
    }
    
    private func addItem(color:UIColor) {
        let item = UIView()
        item.isUserInteractionEnabled = false
        item.translatesAutoresizingMaskIntoConstraints = false
        item.backgroundColor = color
        addSubview(item)
        item.topAnchor.constraint(equalTo:topAnchor, constant:itemY).isActive = true
        item.leftAnchor.constraint(equalTo:leftAnchor, constant:itemX).isActive = true
        item.widthAnchor.constraint(equalToConstant:BoardStackView.width).isActive = true
        item.heightAnchor.constraint(equalToConstant:BoardStackView.height).isActive = true
        itemY += BoardStackView.height
        itemY += BoardStackView.spacing
    }
}
