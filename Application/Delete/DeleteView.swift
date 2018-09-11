import UIKit

class DeleteView:PopupView<DeletePresenter> {
    weak var label:UILabel!
    weak var cancel:UIButton!
    weak var delete:UIButton!
    
    override func makeOutlets() {
        super.makeOutlets()
        back.addTarget(presenter, action:#selector(presenter.cancel), for:.touchUpInside)
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize:16, weight:.regular)
        label.text = presenter.edit.title
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)
        self.label = label
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(presenter, action:#selector(presenter.cancel), for:.touchUpInside)
        cancel.setTitleColor(UIColor(white:0, alpha:0.8), for:.normal)
        cancel.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        cancel.setTitle(NSLocalizedString("DeleteView.cancel", comment:String()), for:[])
        cancel.titleLabel!.font = .systemFont(ofSize:14, weight:.medium)
        base.addSubview(cancel)
        self.cancel = cancel
        
        let delete = UIButton()
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.addTarget(presenter, action:#selector(presenter.delete), for:.touchUpInside)
        delete.backgroundColor = #colorLiteral(red: 0.9229999781, green: 0.201000005, blue: 0.3190000057, alpha: 1)
        delete.setTitleColor(.white, for:.normal)
        delete.setTitleColor(UIColor(white:1, alpha:0.3), for:.highlighted)
        delete.setTitle(NSLocalizedString("DeleteView.delete", comment:String()), for:[])
        delete.titleLabel!.font = .systemFont(ofSize:14, weight:.medium)
        base.addSubview(delete)
        self.delete = delete
    }
    
    override func layoutOutlets() {
        super.layoutOutlets()
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
    }
}
