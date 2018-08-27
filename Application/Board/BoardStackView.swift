import UIKit

class BoardStackView:UIView {
    private var itemX:CGFloat = 0
    private var itemY:CGFloat = 0
    private var width:CGFloat = 0
    private var height:CGFloat = 0
    private static let width:CGFloat = 15
    private static let height:CGFloat = 15
    private static let spacing:CGFloat = 2
    
    init() {
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
        for index in 0 ..< progress.columns.count {
            itemY = 0
            if index != 0 {
                itemX += BoardStackView.spacing
            }
            var color:UIColor
            if index == progress.columns.count - 1 {
                color = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
            } else {
                color = #colorLiteral(red: 0.9229999781, green: 0.201000005, blue: 0.3190000057, alpha: 1)
            }
            addItem(color:#colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1).withAlphaComponent(0.2))
            for _ in 0 ..< progress.columns[index] {
                addItem(color:color)
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
