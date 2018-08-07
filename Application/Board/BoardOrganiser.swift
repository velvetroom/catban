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
    private let options:NSStringDrawingOptions
    private let size:CGSize
    
    init() {
        self.left = 0
        self.top = 0
        self.maxY = 0
        self.options = NSStringDrawingOptions([NSStringDrawingOptions.usesFontLeading,
                                               NSStringDrawingOptions.usesLineFragmentOrigin])
        self.size = CGSize(width:Constants.columnWidth, height:Constants.max)
    }
    
    func refresh() {
        self.clearTouch()
        self.left = Constants.left
        self.top = Constants.top
        self.view.presenter.interactor.board.columns.forEach { (column:Column) in
            self.makeHeader(column:column)
            column.cards.forEach{ (card:Card) in
                self.makeCard(column:column, card:card)
            }
            self.makeNewCard(column:column)
            self.left += Constants.columnWidth + Constants.horizontal
            self.top = Constants.top
        }
        self.makeNewColumn()
        self.updateSize()
    }
    
    private func clearTouch() {
        self.view.touch.subviews.forEach { (view:UIView) in view.removeFromSuperview() }
    }
    
    private func makeHeader(column:Column) {
        let item:BoardItemView = BoardItemView()
        item.column = column
        item.set(text:NSAttributedString(string:column.text, attributes:[NSAttributedString.Key.font:
            UIFont.systemFont(ofSize:Constants.headerFont, weight:UIFont.Weight.bold)]))
        item.addTarget(self.view.presenter, action:#selector(self.view.presenter.editColumn(view:)),
                       for:UIControl.Event.touchUpInside)
        self.layout(item:item, height:Constants.headerHeight)
    }
    
    private func makeNewColumn() {
        let item:BoardItemView = BoardItemView()
        item.set(image:#imageLiteral(resourceName: "assetNewColumn.pdf"))
        item.addTarget(self.view.presenter, action:#selector(self.view.presenter.newColumn),
                       for:UIControl.Event.touchUpInside)
        self.layout(item:item, height:Constants.headerHeight)
    }
    
    private func makeCard(column:Column, card:Card) {
        let item:BoardItemView = BoardItemView()
        item.column = column
        item.card = card
        let text:NSAttributedString = NSAttributedString(string:card.text, attributes:[NSAttributedString.Key.font:
            UIFont.systemFont(ofSize:Constants.cardFont, weight:UIFont.Weight.light)])
        let textHeight:CGFloat = ceil(text.boundingRect(with:self.size, options:self.options, context:nil).size.height)
        item.set(text:text)
        item.addTarget(self.view.presenter, action:#selector(self.view.presenter.editCard(view:)),
                       for:UIControl.Event.touchUpInside)
        self.layout(item:item, height:max(Constants.min, ceil(textHeight)))
    }
    
    private func makeNewCard(column:Column) {
        let item:BoardItemView = BoardItemView()
        item.column = column
        item.set(image:#imageLiteral(resourceName: "assetNewCard.pdf"))
        item.addTarget(self.view.presenter, action:#selector(self.view.presenter.newCard(view:)),
                       for:UIControl.Event.touchUpInside)
        self.layout(item:item, height:Constants.newCard)
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
        self.top += height + Constants.vertical
    }
    
    private func updateSize() {
        self.view.scroll.contentSize = CGSize(width:self.left + Constants.columnWidth,
                                              height:self.maxY + Constants.bottom)
        self.view.touch.frame = CGRect(origin:CGPoint.zero, size:self.view.scroll.contentSize)
    }
}

private struct Constants {
    static let top:CGFloat = 12.0
    static let left:CGFloat = 17.0
    static let horizontal:CGFloat = 5.0
    static let vertical:CGFloat = 10.0
    static let bottom:CGFloat = 20.0
    static let columnWidth:CGFloat = 200.0
    static let cardFont:CGFloat = 14.0
    static let headerFont:CGFloat = 18.0
    static let headerHeight:CGFloat = 25.0
    static let newCard:CGFloat = 60.0
    static let max:CGFloat = 10000.0
    static let min:CGFloat = 30.0
}
