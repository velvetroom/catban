import UIKit

class LibraryCellView:UIControl {
    var viewModel:LibraryItem! { didSet {
        name.text = viewModel.name
        progress.value = CGFloat(viewModel.progress)
        DispatchQueue.main.async { [weak self] in self?.progress.setNeedsDisplay() }
    } }
    private weak var name:UILabel!
    private weak var progress:ProgressView!
    override var intrinsicContentSize:CGSize { return CGSize(width:UIView.noIntrinsicMetric, height:48) }
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Application.interface.over
        layer.cornerRadius = 24
        makeOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    func highlight() { alpha = 0.2 }
    func unhighlight() { alpha = 1 }
    
    private func makeOutlets() {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isUserInteractionEnabled = false
        name.font = .systemFont(ofSize:14, weight:.bold)
        name.textColor = Application.interface.text
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
