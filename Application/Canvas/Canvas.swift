import UIKit

class Canvas:UIView {
    private weak var item:CanvasItem?
    private var touch:CGPoint
    
    init() {
        self.touch = CGPoint.zero
        super.init(frame:CGRect.zero)
        self.clipsToBounds = false
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func touchesBegan(_ touches:Set<UITouch>, with:UIEvent?) {
        guard let touch:UITouch = touches.first else { return }
        self.touch = touch.location(in:self)
        self.item = touch.view as? CanvasItem
        self.dragBegin()
    }
    
    override func touchesMoved(_ touches:Set<UITouch>, with:UIEvent?) {
        guard let touch:UITouch = touches.first else { return }
        self.touch = touch.location(in:self)
        self.dragUpdate()
    }
    
    override func touchesCancelled(_ touches:Set<UITouch>, with:UIEvent?) {
        self.dragEnd()
    }
    
    override func touchesEnded(_ touches:Set<UITouch>, with:UIEvent?) {
        self.dragEnd()
    }
    
    private func dragBegin() {
        
    }
    
    private func dragUpdate() {
        
    }
    
    private func dragEnd() {
        
    }
}
