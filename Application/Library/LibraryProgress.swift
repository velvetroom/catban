import UIKit

class LibraryProgress:UIView {
    var progress:CGFloat = 0
    
    init() {
        super.init(frame:.zero)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func draw(_ rect:CGRect) {
        let center = CGPoint(x:rect.midX, y:rect.midY - 10)
        let radius = min(rect.midX, rect.midY) - 26
        let pi_2 = CGFloat.pi / 2
        let end = (CGFloat.pi * 2 * progress) - pi_2
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(tintColor.cgColor)
        context.setLineWidth(6)
        context.addArc(center:center, radius:radius, startAngle:-pi_2, endAngle:end, clockwise:false)
        context.drawPath(using:.stroke)
        context.setStrokeColor(UIColor(white:0, alpha:0.1).cgColor)
        context.setLineWidth(4)
        context.addArc(center:center, radius:radius, startAngle:end + 0.15, endAngle:-pi_2 - 0.15, clockwise:false)
        context.drawPath(using:.stroke)
    }
}
