import UIKit

class LoadingView:UIView {
    weak var circle:CAShapeLayer!
    weak var pulse:CAShapeLayer!
    weak var outer:CAShapeLayer!
    override var tintColor:UIColor! { didSet {
        self.circle.fillColor = self.tintColor.cgColor
        self.pulse.fillColor = self.tintColor.cgColor
        } }
    
    init() {
        super.init(frame:CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
        
        let circle:CAShapeLayer = CAShapeLayer()
        circle.lineWidth = 0.0
        circle.strokeColor = nil
        circle.backgroundColor = nil
        circle.fillColor = self.tintColor.cgColor
        circle.path = self.arch(radius:Constants.circleRadius)
        circle.frame = CGRect(x:0.0, y:0.0, width:Constants.size, height:Constants.size)
        self.circle = circle
        self.layer.addSublayer(circle)
        
        let pulse:CAShapeLayer = CAShapeLayer()
        pulse.lineWidth = 0.0
        pulse.strokeColor = nil
        pulse.backgroundColor = nil
        pulse.fillColor = self.tintColor.cgColor
        pulse.path = self.arch(radius:Constants.circleRadius)
        pulse.frame = CGRect(x:0.0, y:0.0, width:Constants.size, height:Constants.size)
        self.pulse = pulse
        self.layer.addSublayer(pulse)
        
        let groupAnimation:CAAnimationGroup = CAAnimationGroup()
        groupAnimation.animations = [self.animateRadiusPulse(), self.animateRadiusFade(), self.animateAlpha()]
        groupAnimation.duration = Constants.animationGroup
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = CAMediaTimingFillMode.forwards
        self.pulse.add(groupAnimation, forKey:Constants.animationKey)
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { get { return CGSize(width:Constants.size, height:Constants.size) } }
    
    private func animateRadiusPulse() -> CAAnimation {
        let animation:CABasicAnimation = CABasicAnimation(keyPath:Constants.radiusKey)
        animation.duration = Constants.animationPulse
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0.0, 0.2, 1.0)
        animation.fromValue = Constants.pulseStartRadius
        animation.toValue = Constants.pulseMiddleRadius
        return animation
    }
    
    private func animateRadiusFade() -> CAAnimation {
        let animation:CABasicAnimation = CABasicAnimation(keyPath:Constants.radiusKey)
        animation.duration = Constants.animationFade
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0.0, 0.2, 1.0)
        animation.fromValue = Constants.pulseMiddleRadius
        animation.toValue = Constants.pulseEndRadius
        animation.beginTime = Constants.animationPulse
        return animation
    }
    
    private func animateAlpha() -> CAAnimation {
        let animation:CABasicAnimation = CABasicAnimation(keyPath:Constants.alphaKey)
        animation.duration = Constants.animationFade
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0.0, 0.2, 1.0)
        animation.fromValue = Constants.pulseStartAlpha
        animation.toValue = Constants.pulseEndAlpha
        animation.beginTime = Constants.animationPulse
        return animation
    }
    
    private func arch(radius:CGFloat) -> CGPath {
        let path:UIBezierPath = UIBezierPath()
        path.addArc(withCenter:CGPoint(x:Constants.size / 2.0, y:Constants.size / 2.0), radius:radius,
                    startAngle:0.0001, endAngle:0.0, clockwise:true)
        return path.cgPath
    }
}

private struct Constants {
    static let radiusKey:String = "transform.scale"
    static let alphaKey:String = "opacity"
    static let animationKey:String = "animation"
    static let size:CGFloat = 100.0
    static let circleRadius:CGFloat = 15.0
    static let pulseStartRadius:CGFloat = 1.0
    static let pulseMiddleRadius:CGFloat = 1.2
    static let pulseEndRadius:CGFloat = 2.0
    static let pulseStartAlpha:CGFloat = 0.18
    static let pulseEndAlpha:CGFloat = 0.0
    static let animationPulse:TimeInterval = 0.3
    static let animationFade:TimeInterval = 1.2
    static let animationGroup:TimeInterval = 1.5
}
