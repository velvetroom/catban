import UIKit
import CleanArchitecture

class NameView:View<NamePresenter>, UITextFieldDelegate {
    weak var field:UITextField!
    weak var border:UIView!
    
    override func viewDidLoad() {
        self.makeOutlets()
        self.layoutOutlets()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = self.presenter.strategy.title
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        self.field.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillAppear(animated)
        self.field.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_:UITextField) -> Bool {
        self.field.resignFirstResponder()
        return true
    }
    
    private func makeOutlets() {
        let field:UITextField = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.light)
        field.textColor = UIColor.black
        field.tintColor = UIColor.black
        field.autocapitalizationType = UITextAutocapitalizationType.sentences
        field.autocorrectionType = UITextAutocorrectionType.yes
        field.returnKeyType = UIReturnKeyType.done
        field.spellCheckingType = UITextSpellCheckingType.yes
        field.borderStyle = UITextField.BorderStyle.none
        field.clearButtonMode = UITextField.ViewMode.whileEditing
        field.clearsOnBeginEditing = false
        field.clearsOnInsertion = false
        field.keyboardAppearance = UIKeyboardAppearance.light
        field.keyboardType = UIKeyboardType.alphabet
        field.delegate = self
        field.text = self.presenter.strategy.subject.name
        self.field = field
        self.view.addSubview(field)
        
        let border:UIView = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.backgroundColor = UIColor.black
        self.border = border
        self.view.addSubview(border)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem:UIBarButtonItem.SystemItem.save, target:self,
            action:#selector(self.save))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem:UIBarButtonItem.SystemItem.cancel, target:self.presenter,
            action:#selector(self.presenter.cancel))
    }
    
    private func layoutOutlets() {
        self.field.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant:Constants.margin).isActive = true
        self.field.widthAnchor.constraint(equalToConstant:Constants.fieldWidth).isActive = true
        self.field.heightAnchor.constraint(equalToConstant:Constants.fieldHeight).isActive = true
        
        self.border.topAnchor.constraint(equalTo:self.field.bottomAnchor).isActive = true
        self.border.leftAnchor.constraint(equalTo:self.field.leftAnchor).isActive = true
        self.border.rightAnchor.constraint(equalTo:self.field.rightAnchor).isActive = true
        self.border.heightAnchor.constraint(equalToConstant:Constants.border).isActive = true
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
            self.field.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor,
                                            constant:Constants.margin).isActive = true
        } else {
            self.field.topAnchor.constraint(equalTo:self.view.topAnchor, constant:Constants.margin).isActive = true
        }
    }
    
    @objc private func save() {
        self.presenter.update(name:self.field.text!)
    }
}

private struct Constants {
    static let margin:CGFloat = 20.0
    static let border:CGFloat = 1.0
    static let font:CGFloat = 26.0
    static let fieldWidth:CGFloat = 270.0
    static let fieldHeight:CGFloat = 40.0
}
