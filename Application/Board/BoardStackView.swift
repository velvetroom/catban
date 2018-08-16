import UIKit

class BoardStackView:UIView {
    private var itemX:CGFloat
    private var itemY:CGFloat
    private var width:CGFloat
    private var height:CGFloat = 0
    
    init() {
        self.itemX = 0
        self.itemY = 0
        self.width = 0
        self.height = 0
        super.init(frame:CGRect.zero)
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { get { return CGSize(width:self.width, height:self.height) } }
    
    func update(progress:BoardProgressViewModel) {
        self.subviews.forEach { (item:UIView) in item.removeFromSuperview() }
        self.width = 0.0
        self.height = 0.0
        self.itemX = 0.0
        progress.columns.forEach { (items:Int) in
            self.itemY = 0.0
            if !self.subviews.isEmpty {
                self.itemX += Constants.itemSpacing
            }
            self.addItem(color:#colorLiteral(red: 0.9229999781, green: 0.201000005, blue: 0.3190000057, alpha: 1))
            for _:Int in 0 ..< items {
                self.addItem(color:#colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1))
            }
            self.itemX += Constants.itemWidth
            self.height = max(self.height, self.itemY)
        }
        self.width = self.itemX
        self.invalidateIntrinsicContentSize()
    }
    
    private func addItem(color:UIColor) {
        let item:UIView = UIView()
        item.isUserInteractionEnabled = false
        item.translatesAutoresizingMaskIntoConstraints = false
        item.backgroundColor = color
        self.addSubview(item)
        item.topAnchor.constraint(equalTo:self.topAnchor, constant:self.itemY).isActive = true
        item.leftAnchor.constraint(equalTo:self.leftAnchor, constant:self.itemX).isActive = true
        item.widthAnchor.constraint(equalToConstant:Constants.itemWidth).isActive = true
        item.heightAnchor.constraint(equalToConstant:Constants.itemHeight).isActive = true
        self.itemY += Constants.itemHeight
        self.itemY += Constants.itemSpacing
    }
}

private struct Constants {
    static let itemWidth:CGFloat = 35.0
    static let itemHeight:CGFloat = 3.0
    static let itemSpacing:CGFloat = 10.0
}
