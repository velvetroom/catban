import UIKit

class LoadingView:UIView {
    weak var circle:CAShapeLayer!
    weak var pulse:CAShapeLayer!
    weak var outer:CAShapeLayer!
    override var tintColor:UIColor! { didSet {
        circle.fillColor = tintColor.cgColor
        pulse.strokeColor = tintColor.cgColor
    } }
    private static let size:CGFloat = 52
    private static let circleRadius:CGFloat = 10
    private static let pulseMiddleRadius:CGFloat = 1.4
    private static let animationPulse:TimeInterval = 0.2
    private static let animationFade:TimeInterval = 0.7
    
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
        circle.path = arch(radius:LoadingView.circleRadius)
        circle.frame = CGRect(x:0, y:0, width:LoadingView.size, height:LoadingView.size)
        layer.addSublayer(circle)
        self.circle = circle
        
        let pulse = CAShapeLayer()
        pulse.lineWidth = 1
        pulse.strokeColor = tintColor.cgColor
        pulse.backgroundColor = nil
        pulse.fillColor = nil
        pulse.path = arch(radius:LoadingView.circleRadius)
        pulse.frame = CGRect(x:0, y:0, width:LoadingView.size, height:LoadingView.size)
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
    override var intrinsicContentSize:CGSize { return CGSize(width:LoadingView.size, height:LoadingView.size) }
    
    private func animateRadiusPulse() -> CAAnimation {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.duration = LoadingView.animationPulse
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0, 0.2, 1)
        animation.fromValue = 1
        animation.toValue = LoadingView.pulseMiddleRadius
        return animation
    }
    
    private func animateRadiusFade() -> CAAnimation {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.duration = LoadingView.animationFade
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0, 0.2, 1)
        animation.fromValue = LoadingView.pulseMiddleRadius
        animation.toValue = 2.4
        animation.beginTime = LoadingView.animationPulse
        return animation
    }
    
    private func animateAlpha() -> CAAnimation {
        let animation = CABasicAnimation(keyPath:"opacity")
        animation.duration = LoadingView.animationFade
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0, 0.2, 1)
        animation.fromValue = 0.8
        animation.toValue = 0
        animation.beginTime = LoadingView.animationPulse
        return animation
    }
    
    private func arch(radius:CGFloat) -> CGPath {
        let path = UIBezierPath()
        path.addArc(withCenter:CGPoint(x:LoadingView.size / 2, y:LoadingView.size / 2), radius:radius,
                    startAngle:0.0001, endAngle:0, clockwise:true)
        return path.cgPath
    }
}
