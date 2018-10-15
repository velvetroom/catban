import UIKit

class LoadingView:UIView {
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        isUserInteractionEnabled = false
        backgroundColor = .clear
        
        let pulse = CAShapeLayer()
        pulse.fillColor = UIColor.black.cgColor
        pulse.path = UIBezierPath(roundedRect:CGRect(x:50, y:50, width:50, height:50), cornerRadius:8).cgPath
        pulse.frame = CGRect(x:0, y:0, width:150, height:150)
        layer.addSublayer(pulse)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animateRadiusFade(), animateAlpha()]
        groupAnimation.duration = 2.2
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        pulse.add(groupAnimation, forKey:"animation")
        
        let icon = UIImageView(image:#imageLiteral(resourceName: "assetLogoSmall.pdf"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.contentMode = .center
        addSubview(icon)
        
        icon.widthAnchor.constraint(equalToConstant:80).isActive = true
        icon.heightAnchor.constraint(equalToConstant:80).isActive = true
        icon.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { return CGSize(width:150, height:150) }
    
    private func animateRadiusFade() -> CAAnimation {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0, 0.2, 1)
        animation.fromValue = 1
        animation.toValue = 1.3
        animation.beginTime = 0
        return animation
    }
    
    private func animateAlpha() -> CAAnimation {
        let animation = CABasicAnimation(keyPath:"opacity")
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0, 0.2, 1)
        animation.fromValue = 1
        animation.toValue = 0
        animation.beginTime = 0
        return animation
    }
}
