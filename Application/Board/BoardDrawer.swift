import UIKit
import Catban

class BoardDrawer {
    weak var view:BoardView!
    weak var firstColumn:BoardItemView?
    weak var nextColumn:BoardItemView?
    private weak var nextItem:BoardItemView?
    private let card:[NSAttributedString.Key:AnyObject]
    private let options:NSStringDrawingOptions
    private let size:CGSize
    
    init() {
        self.card = [NSAttributedString.Key.font:
            UIFont.systemFont(ofSize:Constants.cardFont, weight:UIFont.Weight.ultraLight)]
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
        let item:BoardHeaderView = BoardHeaderView()
        item.column = column
        item.label.text = column.text
        item.add(target:self.view.presenter, selector:#selector(self.view.presenter.editColumn(view:)))
        self.addColumn(item:item)
        self.layout(item:item, height:Constants.headerHeight, width:Constants.columnWidth)
    }
    
    private func makeNewColumn() {
        let item:BoardButtonView = BoardButtonView()
        item.image.image = #imageLiteral(resourceName: "assetNew.pdf")
        item.add(target:self.view.presenter, selector:#selector(self.view.presenter.newColumn))
        self.addColumn(item:item)
        self.layout(item:item, height:Constants.new, width:Constants.new)
    }
    
    private func makeCard(column:Column, card:Card) {
        let text:NSAttributedString = NSAttributedString(string:card.text, attributes:self.card)
        let textHeight:CGFloat = ceil(text.boundingRect(with:self.size, options:self.options, context:nil).size.height)
        let item:BoardCardView = BoardCardView()
        item.column = column
        item.card = card
        item.label.attributedText = text
        item.add(target:self.view.presenter, selector:#selector(self.view.presenter.editCard(view:)))
        item.gesture.addTarget(self.view, action:#selector(self.view.dragCard(pan:)))
        self.addItem(item:item)
        self.layout(item:item, height:textHeight, width:Constants.columnWidth)
    }
    
    private func makeNewCard(column:Column) {
        let item:BoardButtonView = BoardButtonView()
        item.column = column
        item.image.image = #imageLiteral(resourceName: "assetNew.pdf")
        item.add(target:self.view.presenter, selector:#selector(self.view.presenter.newCard(view:)))
        self.addItem(item:item)
        self.layout(item:item, height:Constants.new, width:Constants.new)
    }
    
    private func layout(item:BoardItemView, height:CGFloat, width:CGFloat) {
        self.nextItem = item
        self.view.content.addSubview(item)
        item.top = item.topAnchor.constraint(equalTo:self.view.content.topAnchor)
        item.left = item.leftAnchor.constraint(equalTo:self.view.content.leftAnchor)
        item.width = item.widthAnchor.constraint(equalToConstant:width)
        item.height = item.heightAnchor.constraint(equalToConstant:height)
        item.top.isActive = true
        item.left.isActive = true
        item.width.isActive = true
        item.height.isActive = true
    }
    
    private func addItem(item:BoardItemView) {
        item.up = self.nextItem
        self.nextItem!.down = item
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
    static let columnWidth:CGFloat = 130.0
    static let cardFont:CGFloat = 14.0
    static let headerHeight:CGFloat = 24.0
    static let new:CGFloat = 30.0
    static let max:CGFloat = 10000.0
}
