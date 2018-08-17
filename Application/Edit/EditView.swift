import UIKit
import CleanArchitecture

class EditView:View<EditPresenter>, UITextViewDelegate {
    weak var text:UITextView!
    weak var layoutBottom:NSLayoutConstraint!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        self.makeOutlets()
        self.layoutOutlets()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = self.presenter.strategyText.title
        NotificationCenter.default.addObserver(forName:UIResponder.keyboardWillChangeFrameNotification, object:nil,
                                               queue:OperationQueue.main) { [weak self] (notification:Notification) in
            self?.keyboardChanged(notification:notification)
        }
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        self.text.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillAppear(animated)
        self.text.resignFirstResponder()
    }
    
    private func makeOutlets() {
        let text:UITextView = UITextView()
        text.clipsToBounds = true
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor.clear
        text.textColor = UIColor.black
        text.tintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        text.alwaysBounceVertical = true
        text.showsHorizontalScrollIndicator = false
        text.returnKeyType = UIReturnKeyType.default
        text.keyboardAppearance = UIKeyboardAppearance.light
        text.autocorrectionType = UITextAutocorrectionType.yes
        text.spellCheckingType = UITextSpellCheckingType.yes
        text.autocapitalizationType = UITextAutocapitalizationType.sentences
        text.keyboardType = UIKeyboardType.alphabet
        text.contentInset = UIEdgeInsets.zero
        text.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.light)
        text.textContainerInset = UIEdgeInsets(top:Constants.insets, left:Constants.insets, bottom:Constants.insets,
                                               right:Constants.insets)
        text.text = self.presenter.strategyText.text
        self.text = text
        self.view.addSubview(text)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(
            barButtonSystemItem:UIBarButtonItem.SystemItem.done, target:self, action:#selector(self.save)),
            UIBarButtonItem(image:#imageLiteral(resourceName: "assetInfo.pdf"), style:UIBarButtonItem.Style.plain, target:nil, action:nil)]
        
        if self.presenter.strategyDelete == nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem:UIBarButtonItem.SystemItem.cancel, target:self.presenter,
                action:#selector(self.presenter.cancel))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem:UIBarButtonItem.SystemItem.stop, target:self.presenter,
                action:#selector(self.presenter.delete))
        }
    }
    
    private func layoutOutlets() {
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
            self.text.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
            self.text.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.layoutBottom = self.text.bottomAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            self.text.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
            self.layoutBottom = self.text.bottomAnchor.constraint(equalTo:self.view.bottomAnchor)
        }
        self.text.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.text.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        self.layoutBottom.isActive = true
    }
    
    @objc private func save() {
        self.presenter.save(text:self.text.text)
    }
    
    private func keyboardChanged(notification:Notification) {
        self.layoutBottom?.constant = self.keyboardHeightFrom(notification:notification)
        UIView.animate(withDuration:self.animationDurationFrom(notification:notification)) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func keyboardHeightFrom(notification:Notification) -> CGFloat {
        let rect:CGRect = self.keyboardRectFrom(notification:notification)
        let height:CGFloat = self.view.bounds.height
        if rect.minY < height {
            return -rect.height
        }
        return 0
    }
    
    private func keyboardRectFrom(notification:Notification) -> CGRect {
        guard
            let userInfo:[AnyHashable:Any] = notification.userInfo,
            let frameValue:NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return CGRect.zero }
        return frameValue.cgRectValue
    }
    
    private func animationDurationFrom(notification:Notification) -> TimeInterval {
        guard
            let userInfo:[AnyHashable:Any] = notification.userInfo,
            let duration:NSNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        else { return 0 }
        return duration.doubleValue
    }
}

private struct Constants {
    static let font:CGFloat = 28.0
    static let insets:CGFloat = 12.0
}
