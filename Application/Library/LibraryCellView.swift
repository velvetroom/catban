import UIKit

class LibraryCellView:UIControl {
    weak var name:UILabel!
    weak var progress:ProgressView!
    var viewModel:LibraryItem! { didSet {
        name.text = viewModel.name
        progress.value = CGFloat(viewModel.progress)
        DispatchQueue.main.async { [weak self] in self?.progress.setNeedsDisplay() }
    } }
    
    init() {
        super.init(frame:.zero)
        layer.shadowRadius = 8
        layer.cornerRadius = 20
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width:0, height:4)
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
        
        let progress = ProgressView()
        progress.dimAlpha = 0.15
        addSubview(progress)
        self.progress = progress
    }
    
    private func layoutOutlets() {
        name.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:progress.rightAnchor).isActive = true
        
        progress.topAnchor.constraint(equalTo:topAnchor, constant:4).isActive = true
        progress.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-4).isActive = true
        progress.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        progress.widthAnchor.constraint(equalToConstant:42).isActive = true
    }
}
