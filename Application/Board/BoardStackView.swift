import UIKit

class BoardStackView:UIView {
    var viewModel = [(CGFloat, CGFloat)]() { didSet { setNeedsDisplay() } }
    override var intrinsicContentSize:CGSize { return CGSize(width:160, height:160) }
    
    init() {
        super.init(frame:.zero)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func draw(_ rect:CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let center = CGPoint(x:rect.midX, y:rect.midY)
        context.setFillColor(#colorLiteral(red: 0.2349999994, green: 0.7220000029, blue: 1, alpha: 1).withAlphaComponent(0.08).cgColor)
        context.addArc(center:center, radius:60, startAngle:0.0001, endAngle:0, clockwise:false)
        context.setLineCap(.round)
        context.drawPath(using:.fill)
        viewModel.forEach { item in
            if viewModel.last! == item {
                context.setStrokeColor(#colorLiteral(red: 0.2349999994, green: 0.7220000029, blue: 1, alpha: 1).cgColor)
                context.setLineWidth(10)
            } else {
                context.setStrokeColor(#colorLiteral(red: 0.9229999781, green: 0.201000005, blue: 0.3190000057, alpha: 1).cgColor)
                context.setLineWidth(4)
            }
            context.addArc(center:center, radius:70, startAngle:item.0, endAngle:item.1, clockwise:false)
            context.drawPath(using:.stroke)
        }
    }
}
