import UIKit
import Domain

class BoardDrawer {
    weak var view:BoardView!
    weak var firstColumn:BoardItemView?
    weak var nextColumn:BoardItemView?
    private weak var nextItem:BoardItemView?
    private let header:[NSAttributedString.Key:AnyObject]
    private let card:[NSAttributedString.Key:AnyObject]
    private let options:NSStringDrawingOptions
    private let size:CGSize
    
    init() {
        self.header = [NSAttributedString.Key.font:
            UIFont.systemFont(ofSize:Constants.headerFont, weight:UIFont.Weight.bold)]
        self.card = [NSAttributedString.Key.font:
            UIFont.systemFont(ofSize:Constants.cardFont, weight:UIFont.Weight.light)]
        self.options = NSStringDrawingOptions([NSStringDrawingOptions.usesFontLeading,
                                               NSStringDrawingOptions.usesLineFragmentOrigin])
        self.size = CGSize(width:Constants.columnWidth, height:Constants.max)
    }
    
    func draw() {
        self.clearContent()
        self.view.presenter.interactor.board.columns.forEach { (column:Column) in
            self.makeHeader(column:column)
            column.cards.forEach{ (card:Card) in
                self.makeCard(column:column, card:card)
            }
            self.makeNewCard(column:column)
        }
        self.makeNewColumn()
    }
    
    private func clearContent() {
        self.firstColumn = nil
        self.view.content.subviews.forEach { (view:UIView) in view.removeFromSuperview() }
    }
    
    private func makeHeader(column:Column) {
        let item:BoardItemView = BoardItemView()
        item.column = column
        item.label.attributedText = NSAttributedString(string:column.text, attributes:self.header)
        item.addTarget(self.view.presenter, action:#selector(self.view.presenter.editColumn(view:)),
                       for:UIControl.Event.touchUpInside)
        self.addColumn(item:item)
        self.layout(item:item, height:Constants.headerHeight)
    }
    
    private func makeNewColumn() {
        let item:BoardItemView = BoardItemView()
        item.image.image = #imageLiteral(resourceName: "assetNewColumn.pdf")
        item.addTarget(self.view.presenter, action:#selector(self.view.presenter.newColumn),
                       for:UIControl.Event.touchUpInside)
        self.addColumn(item:item)
        self.layout(item:item, height:Constants.headerHeight)
    }
    
    private func makeCard(column:Column, card:Card) {
        let item:BoardItemView = BoardItemView()
        item.column = column
        item.card = card
        let text:NSAttributedString = NSAttributedString(string:card.text, attributes:self.card)
        let textHeight:CGFloat = ceil(text.boundingRect(with:self.size, options:self.options, context:nil).size.height)
        item.label.attributedText = text
        item.addTarget(self.view.presenter, action:#selector(self.view.presenter.editCard(view:)),
                       for:UIControl.Event.touchUpInside)
        item.addGestureRecognizer(UIPanGestureRecognizer(target:self.view, action:#selector(self.view.dragCard(pan:))))
        self.nextItem!.down = item
        self.layout(item:item, height:max(Constants.min, ceil(textHeight)))
    }
    
    private func makeNewCard(column:Column) {
        let item:BoardItemView = BoardItemView()
        item.column = column
        item.image.image = #imageLiteral(resourceName: "assetNewCard.pdf")
        item.addTarget(self.view.presenter, action:#selector(self.view.presenter.newCard(view:)),
                       for:UIControl.Event.touchUpInside)
        self.nextItem!.down = item
        self.layout(item:item, height:Constants.newCard)
    }
    
    private func layout(item:BoardItemView, height:CGFloat) {
        self.nextItem = item
        self.view.content.addSubview(item)
        item.top = item.topAnchor.constraint(equalTo:self.view.content.topAnchor)
        item.left = item.leftAnchor.constraint(equalTo:self.view.content.leftAnchor)
        item.width = item.widthAnchor.constraint(equalToConstant:Constants.columnWidth)
        item.height = item.heightAnchor.constraint(equalToConstant:height)
        item.top.isActive = true
        item.left.isActive = true
        item.width.isActive = true
        item.height.isActive = true
    }
    
    private func addColumn(item:BoardItemView) {
        if self.firstColumn == nil {
            self.firstColumn = item
        }
        self.nextColumn?.right = item
        self.nextColumn = item
    }
}

private struct Constants {
    static let columnWidth:CGFloat = 200.0
    static let cardFont:CGFloat = 14.0
    static let headerFont:CGFloat = 18.0
    static let headerHeight:CGFloat = 25.0
    static let newCard:CGFloat = 60.0
    static let max:CGFloat = 10000.0
    static let min:CGFloat = 45.0
}
