import UIKit

class TodayCellView:UIControl {
    let item:LibraryItem
    
    init(item:LibraryItem) {
        self.item = item
        super.init(frame:.zero)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        makeOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    @objc func highlight() { alpha = 0.1 }
    @objc func unhighlight() { alpha = 1 }
    
    override func draw(_ rect:CGRect) {
        let center = CGPoint(x:rect.midX, y:rect.midY - 10)
        let radius = min(rect.midX, rect.midY) - 26
        let pi_2 = CGFloat.pi / 2
        let end = (CGFloat.pi * 2 * CGFloat(item.progress)) - pi_2
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(6)
        context.addArc(center:center, radius:radius, startAngle:-pi_2, endAngle:end, clockwise:false)
        context.drawPath(using:.stroke)
        context.setStrokeColor(UIColor(white:0, alpha:0.1).cgColor)
        context.setLineWidth(4)
        context.addArc(center:center, radius:radius, startAngle:end + 0.15, endAngle:-pi_2 - 0.15, clockwise:false)
        context.drawPath(using:.stroke)
    }
    
    private func makeOutlets() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize:11, weight:.light)
        label.textColor = .black
        label.textAlignment = .center
        label.text = item.name
        addSubview(label)
        label.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-12).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor, constant:6).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor, constant:-6).isActive = true
    }
}
