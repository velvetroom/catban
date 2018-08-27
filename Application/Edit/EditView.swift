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
        text.font = UIFont.systemFont(ofSize:28, weight:.light)
        text.textContainerInset = UIEdgeInsets(top:12, left:12, bottom:12, right:12)
        text.text = presenter.editText.subject?.text
        view.addSubview(text)
        self.text = text
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetDone.pdf"), style:.plain, target:self, action:#selector(save))]
        
        if presenter.infoSource != nil {
            navigationItem.rightBarButtonItems!.append(
                UIBarButtonItem(image:#imageLiteral(resourceName: "assetInfo.pdf"), style:.plain, target:presenter, action:#selector(presenter.info)))
        }
        
        if presenter.strategyDelete == nil {
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
            return -rect.height
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
}
