import UIKit

class LibraryCellView:UIControl {
    weak var name:UILabel!
    weak var progress:UIProgressView!
    var viewModel:LibraryItemViewModel! { didSet {
        self.name.text = self.viewModel.name
        let progress:Float = self.viewModel.progress
        DispatchQueue.main.async { [weak self] in self?.progress.setProgress(progress, animated:true) }
    } }
    
    init() {
        super.init(frame:CGRect.zero)
        self.makeOutlets()
        self.layoutOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func highlight() {
        self.backgroundColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
    }
    
    func unhighlight() {
        self.backgroundColor = UIColor.clear
    }
    
    private func makeOutlets() {
        let name:UILabel = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isUserInteractionEnabled = false
        name.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.regular)
        name.textColor = UIColor.black
        self.name = name
        self.addSubview(name)
        
        let progress:UIProgressView = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.isUserInteractionEnabled = false
        progress.progressTintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        progress.trackTintColor = UIColor(white:0.99, alpha:1.0)
        self.progress = progress
        self.addSubview(progress)
    }
    
    private func layoutOutlets() {
        self.name.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        self.name.leftAnchor.constraint(equalTo:self.leftAnchor, constant:Constants.left).isActive = true
        
        self.progress.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        self.progress.leftAnchor.constraint(equalTo:self.leftAnchor).isActive = true
        self.progress.rightAnchor.constraint(equalTo:self.rightAnchor).isActive = true
        self.progress.heightAnchor.constraint(equalToConstant:Constants.progress).isActive = true
    }
}

private struct Constants {
    static let left:CGFloat = 20.0
    static let font:CGFloat = 14.0
    static let progress:CGFloat = 4.0
}
