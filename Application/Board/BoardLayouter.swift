import UIKit

class BoardLayouter {
    weak var view:BoardView!
    
    func layout() {
        var left:CGFloat = 17
        var maxY:CGFloat = 0
        var column = view.drawer.firstColumn
        while let currentColumn = column {
            var top:CGFloat = 0
            var item = column
            while let currentItem = item {
                top += 15
                item?.top.constant = top
                item?.left.constant = left
                item = currentItem.down
                top += currentItem.height.constant
                maxY = max(maxY, top)
            }
            column = currentColumn.right
            left += currentColumn.width.constant + 30
        }
        update(width:left, height:maxY)
    }
    
    func detach(item:BoardCardView) {
        item.up?.down = item.down
        item.down?.up = item.up
        layout()
        view.presenter.detach(item:item)
    }
    
    func attach(item:BoardCardView) {
        var column = view.drawer.firstColumn!
        let midX = item.left.constant + (item.width.constant / 2)
        while column.frame.maxX < midX {
            if let right = column.right as? BoardHeaderView {
                column = right
            } else {
                break
            }
        }
        var parent = column
        while let child = parent.down as? BoardCardView {
            if child.top.constant > item.top.constant {
                break
            }
            parent = child
        }
        item.up = parent
        item.down = parent.down
        parent.down?.up = item
        parent.down = item
        layout()
        view.presenter.attach(item:item, after:parent)
    }

    private func update(width:CGFloat, height:CGFloat) {
        view.scroll.contentSize = CGSize(width:width, height:height + 80)
        view.content.frame = CGRect(origin:.zero, size:view.scroll.contentSize)
    }
}
