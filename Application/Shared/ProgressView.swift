import UIKit

class ProgressView:UIView {
    var value:CGFloat = 0
    var lineWidth:CGFloat = 6
    
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
        context.setLineCap(.round)
        context.setStrokeColor(UIColor.catBlue.cgColor)
        if value == 0 {
            context.setStrokeColor(UIColor.catRed.cgColor)
            context.setLineWidth(2)
            context.addArc(center:center, radius:radius, startAngle:0.0001, endAngle:0, clockwise:false)
            context.drawPath(using:.stroke)
        } else {
            context.setLineWidth(lineWidth)
            context.addArc(center:center, radius:radius, startAngle:-pi_2, endAngle:end, clockwise:false)
            context.drawPath(using:.stroke)
            let residual = end + 0.3
            let max = (CGFloat.pi * 2) - (pi_2 + 0.3)
            if residual < max {
                context.setStrokeColor(UIColor.catRed.cgColor)
                context.setLineWidth(2)
                context.addArc(center:center, radius:radius, startAngle:residual, endAngle:max, clockwise:false)
                context.drawPath(using:.stroke)
            }
        }
    }
}
