import UIKit

class BoardLayouter {
    weak var view:BoardView!
    
    func layout() {
        var left:CGFloat = Constants.left
        var maxY:CGFloat = 0
        var column:BoardItemView? = self.view.drawer.firstColumn
        while let currentColumn:BoardItemView = column {
            var top:CGFloat = Constants.top
            var item:BoardItemView? = currentColumn
            while let currentItem:BoardItemView = item {
                item?.top.constant = top
                item?.left.constant = left
                item = currentItem.down
                top += currentItem.height.constant + Constants.vertical
                maxY = max(maxY, top)
            }
            column = currentColumn.right
            left += currentColumn.width.constant + Constants.horizontal
        }
        self.update(width:left, height:maxY)
    }
    
    func detach(item:BoardItemView) {
        item.up?.down = item.down
        item.down?.up = item.up
        self.layout()
    }
    
    func attach(item:BoardItemView) {
        var column:BoardItemView = self.view.drawer.firstColumn!
        while column.frame.maxX < item.frame.midX {
            if column.right?.right != nil {
                column = column.right!
            } else {
                break
            }
        }
        var parent:BoardItemView = column
        while let child:BoardItemView = parent.down {
            if child.top.constant > item.top.constant || child.down == nil {
                break
            }
            parent = child
        }
        item.up = parent
        item.down = parent.down
        parent.down?.up = item
        parent.down = item
        self.layout()
    }

    private func update(width:CGFloat, height:CGFloat) {
        self.view.scroll.contentSize = CGSize(width:width, height:height + Constants.bottom)
        self.view.content.frame = CGRect(origin:CGPoint.zero, size:self.view.scroll.contentSize)
    }
}

private struct Constants {
    static let top:CGFloat = 12.0
    static let left:CGFloat = 17.0
    static let horizontal:CGFloat = 5.0
    static let vertical:CGFloat = 10.0
    static let bottom:CGFloat = 20.0
}
