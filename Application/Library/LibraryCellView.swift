import UIKit

class LibraryCellView:UIControl {
    var viewModel:LibraryItem! { didSet {
        name.text = viewModel.name
        progress.value = CGFloat(viewModel.progress)
        DispatchQueue.main.async { [weak self] in self?.progress.setNeedsDisplay() }
    } }
    private weak var name:UILabel!
    private weak var progress:ProgressView!
    
    init() {
        super.init(frame:.zero)
        backgroundColor = .white
        layer.shadowRadius = 2
        layer.cornerRadius = 24
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width:0, height:1)
        makeOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    func highlight() { UIView.animate(withDuration:0.3) { [weak self] in self?.alpha = 0.2 } }
    func unhighlight() { UIView.animate(withDuration:0.3) { [weak self] in self?.alpha = 1 } }
    
    private func makeOutlets() {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isUserInteractionEnabled = false
        name.font = .systemFont(ofSize:14, weight:.bold)
        name.textColor = .black
        addSubview(name)
        self.name = name
        
        let progress = ProgressView()
        progress.lineWidth = 3
        addSubview(progress)
        self.progress = progress
        
        name.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:progress.rightAnchor, constant:6).isActive = true
        
        progress.topAnchor.constraint(equalTo:topAnchor, constant:6).isActive = true
        progress.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-6).isActive = true
        progress.leftAnchor.constraint(equalTo:leftAnchor, constant:4).isActive = true
        progress.widthAnchor.constraint(equalToConstant:42).isActive = true
    }
}
