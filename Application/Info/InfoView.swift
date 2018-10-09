import CleanArchitecture

class InfoView:PopupView<InfoPresenter> {
    private weak var text:UITextView!
    
    override func viewDidLoad() {
        configureViewModel()
        super.viewDidLoad()
    }
    
    override func makeOutlets() {
        super.makeOutlets()
        back.addTarget(presenter, action:#selector(presenter.dismiss), for:.touchUpInside)
        
        let text = UITextView()
        text.clipsToBounds = true
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.textColor = .black
        text.tintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        text.alwaysBounceVertical = true
        text.showsHorizontalScrollIndicator = false
        text.isEditable = false
        text.contentInset = .zero
        text.textContainerInset = UIEdgeInsets(top:30, left:12, bottom:30, right:12)
        base.addSubview(text)
        self.text = text
        
        let dismiss = UIButton()
        dismiss.translatesAutoresizingMaskIntoConstraints = false
        dismiss.addTarget(presenter, action:#selector(presenter.dismiss), for:.touchUpInside)
        dismiss.setTitleColor(.white, for:.normal)
        dismiss.setTitleColor(UIColor(white:1, alpha:0.2), for:.highlighted)
        dismiss.setTitle(.local("InfoView.dismiss"), for:[])
        dismiss.titleLabel!.font = .systemFont(ofSize:14, weight:.bold)
        view.addSubview(dismiss)
        
        base.leftAnchor.constraint(equalTo:view.leftAnchor, constant:15).isActive = true
        base.rightAnchor.constraint(equalTo:view.rightAnchor,constant:-15).isActive = true
        base.topAnchor.constraint(equalTo:view.topAnchor, constant:45).isActive = true
        base.bottomAnchor.constraint(equalTo:dismiss.topAnchor).isActive = true
        
        dismiss.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        dismiss.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-15).isActive = true
        dismiss.heightAnchor.constraint(equalToConstant:50).isActive = true
        dismiss.widthAnchor.constraint(equalToConstant:150).isActive = true
        
        text.topAnchor.constraint(equalTo:base.topAnchor, constant:2).isActive = true
        text.bottomAnchor.constraint(equalTo:base.bottomAnchor, constant:-2).isActive = true
        text.leftAnchor.constraint(equalTo:base.leftAnchor).isActive = true
        text.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
    }
    
    private func configureViewModel() {
        presenter.viewModel { [weak self] (text:NSAttributedString) in
            self?.text.attributedText = text
        }
    }
}
