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
        self.left = Constants.Content.left
        self.top = 0
        self.view.presenter.interactor.board.columns.forEach { (column:Column) in
            self.left += Constants.Column.width
            self.top = 0
        }
        self.makeNewColumn()
        self.updateSize()
    }
    
    private func clearTouch() {
        self.view.touch.subviews.forEach { (view:UIView) in view.removeFromSuperview() }
    }
    
    private func makeNewColumn() {
        let item:BoardNewColumnView = BoardNewColumnView()
        self.view.touch.addSubview(item)
        self.layout(item:item, height:Constants.Column.height)
    }
    
    private func layout(item:BoardItemView, height:CGFloat) {
        item.top = item.topAnchor.constraint(equalTo:self.view.touch.topAnchor, constant:self.top)
        item.left = item.leftAnchor.constraint(equalTo:self.view.touch.leftAnchor, constant:self.left)
        item.width = item.widthAnchor.constraint(equalToConstant:Constants.Column.width)
        item.height = item.heightAnchor.constraint(equalToConstant:height)
        item.top.isActive = true
        item.left.isActive = true
        item.width.isActive = true
        item.height.isActive = true
        self.top += height + Constants.Content.spacing
    }
    
    private func updateSize() {
        self.view.scroll.contentSize = CGSize(width:self.left + Constants.Column.width,
                                         height:self.maxY + Constants.Content.bottom)
        self.view.touch.frame = CGRect(origin:CGPoint.zero, size:self.view.scroll.contentSize)
    }
}

private struct Constants {
    struct Content {
        static let left:CGFloat = 6.0
        static let spacing:CGFloat = 3.0
        static let bottom:CGFloat = 20.0
    }
    
    struct Column {
        static let height:CGFloat = 40.0
        static let width:CGFloat = 160.0
    }
}
