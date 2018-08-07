import UIKit
import Domain

class BoardOrganiser {
    weak var view:BoardView!
    var left:CGFloat
    var maxY:CGFloat
    var top:CGFloat { didSet {
        if self.top > self.maxY {
            self.maxY = self.top
        }
    } }
    
    init() {
        self.left = 0
        self.top = 0
        self.maxY = 0
    }
    
    func refresh() {
        self.clearTouch()
        self.left = Constants.left
        self.top = 0
        self.view.presenter.interactor.board.columns.forEach { (column:Column) in
            self.makeHeader(column:column)
            self.makeNewCard()
            self.left += Constants.columnWidth + Constants.spacing
            self.top = 0
        }
        self.makeNewColumn()
        self.updateSize()
    }
    
    private func clearTouch() {
        self.view.touch.subviews.forEach { (view:UIView) in view.removeFromSuperview() }
    }
    
    private func makeHeader(column:Column) {
        let item:BoardItemView = BoardItemView()
        item.set(text:NSAttributedString(string:column.name, attributes:[NSAttributedString.Key.font:
            UIFont.systemFont(ofSize:Constants.headerFont, weight:UIFont.Weight.bold)]))
        self.layout(item:item, height:Constants.headerHeight)
    }
    
    private func makeNewColumn() {
        let item:BoardItemView = BoardItemView()
        item.set(image:#imageLiteral(resourceName: "assetNewColumn.pdf"))
        item.addTarget(self.view.presenter, action:#selector(self.view.presenter.newColumn),
                       for:UIControl.Event.touchUpInside)
        self.layout(item:item, height:Constants.headerHeight)
    }
    
    private func makeNewCard() {
        let item:BoardItemView = BoardItemView()
        item.set(image:#imageLiteral(resourceName: "assetNewCard.pdf"))
        item.addTarget(self.view.presenter, action:#selector(self.view.presenter.newColumn),
                       for:UIControl.Event.touchUpInside)
        self.layout(item:item, height:Constants.cardHeight)
    }
    
    private func layout(item:BoardItemView, height:CGFloat) {
        self.view.touch.addSubview(item)
        item.top = item.topAnchor.constraint(equalTo:self.view.touch.topAnchor, constant:self.top)
        item.left = item.leftAnchor.constraint(equalTo:self.view.touch.leftAnchor, constant:self.left)
        item.width = item.widthAnchor.constraint(equalToConstant:Constants.columnWidth)
        item.height = item.heightAnchor.constraint(equalToConstant:height)
        item.top.isActive = true
        item.left.isActive = true
        item.width.isActive = true
        item.height.isActive = true
        self.top += height
    }
    
    private func updateSize() {
        self.view.scroll.contentSize = CGSize(width:self.left + Constants.columnWidth,
                                              height:self.maxY + Constants.bottom)
        self.view.touch.frame = CGRect(origin:CGPoint.zero, size:self.view.scroll.contentSize)
    }
}

private struct Constants {
    static let left:CGFloat = 17.0
    static let spacing:CGFloat = 3.0
    static let bottom:CGFloat = 20.0
    static let columnWidth:CGFloat = 200.0
    static let headerFont:CGFloat = 18
    static let headerHeight:CGFloat = 40.0
    static let cardHeight:CGFloat = 70
}
