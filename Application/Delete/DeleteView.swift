import UIKit

class DeleteView:PopupView<DeletePresenter> {
    override func makeOutlets() {
        super.makeOutlets()
        back.addTarget(presenter, action:#selector(presenter.cancel), for:.touchUpInside)
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize:18, weight:.light)
        label.text = presenter.edit.title
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(presenter, action:#selector(presenter.cancel), for:.touchUpInside)
        cancel.setTitleColor(UIColor(white:0, alpha:0.4), for:.normal)
        cancel.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        cancel.setTitle(.local("DeleteView.cancel"), for:[])
        cancel.titleLabel!.font = .systemFont(ofSize:14, weight:.bold)
        base.addSubview(cancel)
        
        let delete = UIButton()
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.addTarget(presenter, action:#selector(presenter.delete), for:.touchUpInside)
        delete.backgroundColor = .catRed
        delete.setTitleColor(.white, for:.normal)
        delete.setTitleColor(UIColor(white:1, alpha:0.3), for:.highlighted)
        delete.setTitle(.local("DeleteView.delete"), for:[])
        delete.titleLabel!.font = .systemFont(ofSize:14, weight:.bold)
        delete.layer.cornerRadius = 6
        base.addSubview(delete)
        
        base.widthAnchor.constraint(equalToConstant:320).isActive = true
        base.heightAnchor.constraint(equalToConstant:200).isActive = true
        base.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        base.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        label.topAnchor.constraint(equalTo:base.topAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo:base.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant:95).isActive = true
        
        cancel.leftAnchor.constraint(equalTo:base.leftAnchor).isActive = true
        cancel.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:delete.bottomAnchor).isActive = true
        cancel.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        delete.leftAnchor.constraint(equalTo:base.leftAnchor, constant:14).isActive = true
        delete.rightAnchor.constraint(equalTo:base.rightAnchor, constant:-14).isActive = true
        delete.topAnchor.constraint(equalTo:label.bottomAnchor).isActive = true
        delete.heightAnchor.constraint(equalToConstant:48).isActive = true
    }
}
