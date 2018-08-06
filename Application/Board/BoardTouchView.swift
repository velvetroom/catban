import UIKit

class BoardTouchView:UIView {
    private weak var item:BoardItemView?
    private var touch:CGPoint
    
    init() {
        self.touch = CGPoint.zero
        super.init(frame:CGRect.zero)
        self.clipsToBounds = false
    }
    
    required init?(coder:NSCoder) { return nil }
    override func touchesCancelled(_ touches:Set<UITouch>, with:UIEvent?) { self.dragEnd() }
    override func touchesEnded(_ touches:Set<UITouch>, with:UIEvent?) { self.dragEnd() }
    
    override func touchesBegan(_ touches:Set<UITouch>, with:UIEvent?) {
        guard let touch:UITouch = touches.first else { return }
        self.touch = touch.location(in:self)
        self.item = touch.view as? BoardItemView
        self.dragBegin()
    }
    
    override func touchesMoved(_ touches:Set<UITouch>, with:UIEvent?) {
        guard let touch:UITouch = touches.first else { return }
        self.touch = touch.location(in:self)
        self.dragUpdate()
    }
    
    private func dragBegin() {
        
    }
    
    private func dragUpdate() {
        
    }
    
    private func dragEnd() {
        
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
