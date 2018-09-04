import UIKit

class LibraryProgress:UIView {
    var value:CGFloat = 0
    
    init() {
        super.init(frame:.zero)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func draw(_ rect:CGRect) {
        let center = CGPoint(x:rect.midX, y:rect.midY)
        let radius = min(rect.midX, rect.midY) - 5
        let pi_2 = CGFloat.pi / 2
        let end = (CGFloat.pi * 2 * value) - pi_2
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(tintColor.withAlphaComponent(0.05).cgColor)
        context.addArc(center:center, radius:radius - 7, startAngle:0.0001, endAngle:0, clockwise:false)
        context.drawPath(using:.fill)
        context.setStrokeColor(tintColor.cgColor)
        context.setLineWidth(6)
        context.addArc(center:center, radius:radius, startAngle:-pi_2, endAngle:end, clockwise:false)
        context.drawPath(using:.stroke)
        context.setStrokeColor(tintColor.withAlphaComponent(0.05).cgColor)
        context.setLineWidth(4)
        context.addArc(center:center, radius:radius, startAngle:end + 0.15, endAngle:-pi_2 - 0.15, clockwise:false)
        context.drawPath(using:.stroke)
    }
}
