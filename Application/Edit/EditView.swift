import UIKit
import CleanArchitecture

class EditView:View<EditPresenter>, UITextViewDelegate {
    weak var text:UITextView!
    weak var layoutBottom:NSLayoutConstraint!
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        makeOutlets()
        layoutOutlets()
        super.viewDidLoad()
        view.backgroundColor = .white
        title = presenter.editText.title
        NotificationCenter.default.addObserver(forName:UIResponder.keyboardWillChangeFrameNotification, object:
            nil, queue:.main) { [weak self] (notification) in self?.keyboardChanged(notification:notification) }
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        text.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillAppear(animated)
        text.resignFirstResponder()
    }
    
    private func makeOutlets() {
        let text = UITextView()
        text.clipsToBounds = true
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.textColor = .black
        text.tintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        text.alwaysBounceVertical = true
        text.showsHorizontalScrollIndicator = false
        text.returnKeyType = .default
        text.keyboardAppearance = .light
        text.autocorrectionType = .yes
        text.spellCheckingType = .yes
        text.autocapitalizationType = .sentences
        text.keyboardType = .alphabet
        text.contentInset = .zero
        text.font = .systemFont(ofSize:28, weight:.light)
        text.textContainerInset = UIEdgeInsets(top:12, left:12, bottom:12, right:12)
        text.text = presenter.editText.subject?.text
        view.addSubview(text)
        self.text = text
        
        let accessory = UIView(frame:CGRect(x:0, y:0, width:0, height:34))
        accessory.backgroundColor = .white
        text.inputAccessoryView = accessory
        
        let pound = addKey(title:"#")
        let list = addKey(title:"-")
        let underscore = addKey(title:"_")
        let asterisk = addKey(title:"*")
        let escaper = addKey(title:"`")
        pound.leftAnchor.constraint(equalTo:accessory.leftAnchor).isActive = true
        list.leftAnchor.constraint(equalTo:pound.rightAnchor, constant:1).isActive = true
        underscore.leftAnchor.constraint(equalTo:list.rightAnchor, constant:1).isActive = true
        asterisk.leftAnchor.constraint(equalTo:underscore.rightAnchor, constant:1).isActive = true
        escaper.leftAnchor.constraint(equalTo:asterisk.rightAnchor, constant:1).isActive = true
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetDone.pdf"), style:.plain, target:self, action:#selector(save))]
        
        if presenter.infoSource != nil {
            navigationItem.rightBarButtonItems!.append(
                UIBarButtonItem(image:#imageLiteral(resourceName: "assetInfo.pdf"), style:.plain, target:presenter, action:#selector(presenter.info)))
        }
        
        if presenter.editDelete == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem:.cancel, target:presenter, action:#selector(presenter.cancel))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem:.stop, target:presenter, action:#selector(presenter.delete))
        }
    }
    
    private func layoutOutlets() {
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            text.contentInsetAdjustmentBehavior = .never
            text.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
            layoutBottom = text.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            text.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
            layoutBottom = text.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        }
        text.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        text.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        layoutBottom.isActive = true
    }
    
    @objc private func save() {
        presenter.save(text:text.text)
    }
    
    private func keyboardChanged(notification:Notification) {
        layoutBottom?.constant = keyboardHeightFrom(notification:notification)
        UIView.animate(withDuration:animationDurationFrom(notification:notification)) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func keyboardHeightFrom(notification:Notification) -> CGFloat {
        let rect = keyboardRectFrom(notification:notification)
        let height = view.bounds.height
        if rect.minY < height {
            return -(rect.height + 2)
        }
        return 0
    }
    
    private func keyboardRectFrom(notification:Notification) -> CGRect {
        guard
            let userInfo = notification.userInfo,
            let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return .zero }
        return frameValue.cgRectValue
    }
    
    private func animationDurationFrom(notification:Notification) -> TimeInterval {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        else { return 0 }
        return duration.doubleValue
    }
    
    private func addKey(title:String) -> UIButton {
        let key = UIButton()
        key.backgroundColor = UIColor(red:0.9, green:0.92, blue:0.95, alpha:1)
        key.translatesAutoresizingMaskIntoConstraints = false
        key.setTitle(title, for:[])
        key.setTitleColor(.black, for:.normal)
        key.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        key.titleLabel!.font = .systemFont(ofSize:14, weight:.bold)
        key.addTarget(self, action:#selector(add(key:)), for:.touchUpInside)
        text.inputAccessoryView!.addSubview(key)
        key.topAnchor.constraint(equalTo:text.inputAccessoryView!.topAnchor).isActive = true
        key.bottomAnchor.constraint(equalTo:text.inputAccessoryView!.bottomAnchor).isActive = true
        key.widthAnchor.constraint(equalTo:text.inputAccessoryView!.widthAnchor, multiplier:0.2,
                                   constant:-1).isActive = true
        return key
    }
    
    @objc private func add(key:UIButton) {
        text.insertText(key.title(for:[])!)
    }
}
