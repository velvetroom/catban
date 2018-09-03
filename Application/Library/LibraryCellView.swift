import UIKit

class LibraryCellView:UIControl {
    weak var name:UILabel!
    weak var progress:LibraryProgress!
    var viewModel:LibraryItem! { didSet {
        name.text = viewModel.name
        progress.value = CGFloat(viewModel.progress)
        DispatchQueue.main.async { [weak self] in self?.progress.setNeedsDisplay() }
    } }
    
    init() {
        super.init(frame:.zero)
        layer.shadowRadius = 3
        layer.cornerRadius = 30
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width:0, height:1)
        makeOutlets()
        layoutOutlets()
        unhighlight()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func highlight() {
        backgroundColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        progress.tintColor = .white
        name.textColor = .white
        progress.setNeedsDisplay()
    }
    
    func unhighlight() {
        backgroundColor = .white
        progress.tintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        name.textColor = .black
        progress.setNeedsDisplay()
    }
    
    private func makeOutlets() {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isUserInteractionEnabled = false
        name.font = .systemFont(ofSize:12, weight:.bold)
        addSubview(name)
        self.name = name
        
        let progress = LibraryProgress()
        addSubview(progress)
        self.progress = progress
    }
    
    private func layoutOutlets() {
        name.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:progress.rightAnchor).isActive = true
        
        progress.topAnchor.constraint(equalTo:topAnchor, constant:8).isActive = true
        progress.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-8).isActive = true
        progress.leftAnchor.constraint(equalTo:leftAnchor, constant:2).isActive = true
        progress.widthAnchor.constraint(equalToConstant:60).isActive = true
    }
}
