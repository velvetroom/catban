import UIKit
import CleanArchitecture

class DeleteView:View<DeletePresenter> {
    weak var blur:UIVisualEffectView!
    weak var back:UIControl!
    weak var base:UIView!
    weak var label:UILabel!
    weak var cancel:UIButton!
    weak var delete:UIButton!
    weak var border:UIView!

    override func viewDidLoad() {
        makeOutlets()
        layoutOutlets()
        super.viewDidLoad()
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = .clear
    }
    
    private func makeOutlets() {
        let blur = UIVisualEffectView(effect:UIBlurEffect(style:.dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        view.addSubview(blur)
        self.blur = blur
        
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(presenter, action:#selector(presenter.cancel), for:.touchUpInside)
        view.addSubview(back)
        self.back = back
        
        let base = UIView()
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .white
        base.layer.cornerRadius = 4
        base.clipsToBounds = true
        view.addSubview(base)
        self.base = base
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize:16, weight:.regular)
        label.text = presenter.strategy.title
        label.textAlignment = .center
        view.addSubview(label)
        self.label = label
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = UIColor(white:0, alpha:0.1)
        border.isUserInteractionEnabled = false
        view.addSubview(border)
        self.border = border
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(presenter, action:#selector(presenter.cancel), for:.touchUpInside)
        cancel.setTitleColor(.black, for:.normal)
        cancel.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        cancel.setTitle(NSLocalizedString("DeleteView.cancel", comment:String()), for:[])
        cancel.titleLabel!.font = UIFont.systemFont(ofSize:14, weight:.medium)
        view.addSubview(cancel)
        self.cancel = cancel
        
        let delete = UIButton()
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.addTarget(presenter, action:#selector(presenter.delete), for:.touchUpInside)
        delete.setTitleColor(#colorLiteral(red: 0.9229999781, green: 0.201000005, blue: 0.3190000057, alpha: 1), for:.normal)
        delete.setTitleColor(#colorLiteral(red: 0.9229999781, green: 0.201000005, blue: 0.3190000057, alpha: 1).withAlphaComponent(0.2), for:.highlighted)
        delete.setTitle(NSLocalizedString("DeleteView.delete", comment:String()), for:[])
        delete.titleLabel!.font = UIFont.systemFont(ofSize:14, weight:.medium)
        view.addSubview(delete)
        self.delete = delete
    }
    
    private func layoutOutlets() {
        blur.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        back.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        back.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        back.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        back.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        base.widthAnchor.constraint(equalToConstant:260).isActive = true
        base.heightAnchor.constraint(equalToConstant:130).isActive = true
        base.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        base.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        label.topAnchor.constraint(equalTo:base.topAnchor, constant:35).isActive = true
        label.centerXAnchor.constraint(equalTo:base.centerXAnchor).isActive = true
        
        cancel.leftAnchor.constraint(equalTo:base.leftAnchor).isActive = true
        cancel.rightAnchor.constraint(equalTo:base.centerXAnchor).isActive = true
        cancel.bottomAnchor.constraint(equalTo:base.bottomAnchor).isActive = true
        cancel.heightAnchor.constraint(equalToConstant:45).isActive = true
        
        delete.leftAnchor.constraint(equalTo:base.centerXAnchor).isActive = true
        delete.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
        delete.bottomAnchor.constraint(equalTo:base.bottomAnchor).isActive = true
        delete.heightAnchor.constraint(equalToConstant:45).isActive = true
        
        border.leftAnchor.constraint(equalTo:base.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
        border.bottomAnchor.constraint(equalTo:base.bottomAnchor).isActive = true
        border.topAnchor.constraint(equalTo:cancel.topAnchor).isActive = true
    }
}
