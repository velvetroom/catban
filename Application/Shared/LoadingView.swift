import UIKit

class LoadingView:UIView {
    weak var circle:CAShapeLayer!
    weak var pulse:CAShapeLayer!
    weak var outer:CAShapeLayer!
    override var tintColor:UIColor! { didSet {
        circle.fillColor = tintColor.cgColor
        pulse.strokeColor = tintColor.cgColor
    } }
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        isUserInteractionEnabled = false
        backgroundColor = .clear
        
        let circle = CAShapeLayer()
        circle.lineWidth = 0
        circle.strokeColor = nil
        circle.backgroundColor = nil
        circle.fillColor = tintColor.cgColor
        circle.path = arch(radius:10)
        circle.frame = CGRect(x:0, y:0, width:52, height:52)
        layer.addSublayer(circle)
        self.circle = circle
        
        let pulse = CAShapeLayer()
        pulse.lineWidth = 1
        pulse.strokeColor = tintColor.cgColor
        pulse.backgroundColor = nil
        pulse.fillColor = nil
        pulse.path = arch(radius:10)
        pulse.frame = CGRect(x:0, y:0, width:52, height:52)
        layer.addSublayer(pulse)
        self.pulse = pulse
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animateRadiusPulse(), animateRadiusFade(), animateAlpha()]
        groupAnimation.duration = 1
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        pulse.add(groupAnimation, forKey:"animation")
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { return CGSize(width:52, height:52) }
    
    private func animateRadiusPulse() -> CAAnimation {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0, 0.2, 1)
        animation.fromValue = 1
        animation.toValue = 1.4
        return animation
    }
    
    private func animateRadiusFade() -> CAAnimation {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0, 0.2, 1)
        animation.fromValue = 1.4
        animation.toValue = 2.4
        animation.beginTime = 0.2
        return animation
    }
    
    private func animateAlpha() -> CAAnimation {
        let animation = CABasicAnimation(keyPath:"opacity")
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0, 0.2, 1)
        animation.fromValue = 0.8
        animation.toValue = 0
        animation.beginTime = 0.2
        return animation
    }
    
    private func arch(radius:CGFloat) -> CGPath {
        let path = UIBezierPath()
        path.addArc(withCenter:CGPoint(x:26, y:26), radius:radius, startAngle:0.001, endAngle:0, clockwise:true)
        return path.cgPath
    }
}
