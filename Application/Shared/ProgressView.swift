import UIKit

class ProgressView:UIView {
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
        context.setFillColor(#colorLiteral(red: 0.2349999994, green: 0.7220000029, blue: 1, alpha: 1).withAlphaComponent(0.1).cgColor)
        context.addArc(center:center, radius:radius - 7, startAngle:0.0001, endAngle:0, clockwise:false)
        context.setLineCap(.round)
        context.drawPath(using:.fill)
        context.setStrokeColor(#colorLiteral(red: 0.2349999994, green: 0.7220000029, blue: 1, alpha: 1).cgColor)
        if value == 0 {
            context.setStrokeColor(#colorLiteral(red: 0.9229999781, green: 0.201000005, blue: 0.3190000057, alpha: 1).cgColor)
            context.setLineWidth(2)
            context.addArc(center:center, radius:radius, startAngle:0.0001, endAngle:0, clockwise:false)
            context.drawPath(using:.stroke)
        } else {
            context.setLineWidth(6)
            context.addArc(center:center, radius:radius, startAngle:-pi_2, endAngle:end, clockwise:false)
            context.drawPath(using:.stroke)
            let residual = end + 0.35
            let max = (CGFloat.pi * 2) - (pi_2 + 0.35)
            if residual < max {
                context.setStrokeColor(#colorLiteral(red: 0.9229999781, green: 0.201000005, blue: 0.3190000057, alpha: 1).cgColor)
                context.setLineWidth(2)
                context.addArc(center:center, radius:radius, startAngle:residual, endAngle:max, clockwise:false)
                context.drawPath(using:.stroke)
            }
        }
    }
}
