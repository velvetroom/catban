import UIKit

class BoardTouchView:UIView {
    init() {
        self.touch = CGPoint.zero
        super.init(frame:CGRect.zero)
        self.clipsToBounds = false
    }
    
    required init?(coder:NSCoder) { return nil }
    override func touchesCancelled(_ touches:Set<UITouch>, with:UIEvent?) { self.dragEnd(touch:touches.first!) }
    override func touchesEnded(_ touches:Set<UITouch>, with:UIEvent?) { self.dragEnd(touch:touches.first!) }
    
    override func touchesBegan(_ touches:Set<UITouch>, with:UIEvent?) {
        guard
            let touch:UITouch = touches.first,
            let item:BoardCardView = touch.view as? BoardCardView
        else { return }
        let point:CGPoint = touch.location(in:self)
        item.dragBegin(point:point)
    }
    
    override func touchesMoved(_ touches:Set<UITouch>, with:UIEvent?) {
        guard
            let touch:UITouch = touches.first,
            let item:BoardCardView = touch.view as? BoardCardView
        else { return }
        let point:CGPoint = touch.location(in:self)
        item.dragUpdate(point:point)
    }
    
    private func dragEnd(touch:UITouch) {
        
    }
    
    private func animateChanges() {
        UIView.animate(withDuration:Constants.animation) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
}

private struct Constants {
    static let animation:TimeInterval = 0.3
}
