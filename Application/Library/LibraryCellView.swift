import UIKit

class LibraryCellView:UIButton {
    weak var name:UILabel!
    weak var border:UIView!
    var viewModel:LibraryItemViewModel! { didSet { self.name.text = self.viewModel.name } }
    
    init() {
        super.init(frame:CGRect.zero)
        self.makeOutlets()
        self.layoutOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func highlight() {
        self.backgroundColor = UIColor(white:0, alpha:0.1)
    }
    
    private func makeOutlets() {
        let name:UILabel = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isUserInteractionEnabled = false
        name.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.light)
        name.textColor = UIColor.black
        self.name = name
        self.addSubview(name)
        
        let border:UIView = UIView()
        border.isUserInteractionEnabled = false
        border.backgroundColor = UIColor(white:0, alpha:0.2)
        border.translatesAutoresizingMaskIntoConstraints = false
        self.border = border
        self.addSubview(border)
    }
    
    private func layoutOutlets() {
        self.name.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        self.name.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        self.name.leftAnchor.constraint(equalTo:self.leftAnchor, constant:Constants.margin).isActive = true
        self.name.rightAnchor.constraint(equalTo:self.rightAnchor, constant:-Constants.margin).isActive = true
        
        self.border.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        self.border.leftAnchor.constraint(equalTo:self.leftAnchor).isActive = true
        self.border.rightAnchor.constraint(equalTo:self.rightAnchor).isActive = true
        self.border.heightAnchor.constraint(equalToConstant:Constants.border).isActive = true
    }
}

private struct Constants {
    static let margin:CGFloat = 20
    static let font:CGFloat = 16
    static let border:CGFloat = 0.5
}
