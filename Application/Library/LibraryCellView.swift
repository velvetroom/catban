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
        backgroundColor = .white
        layer.shadowRadius = 8
        layer.cornerRadius = 24
        layer.shadowOffset = CGSize(width:0, height:4)
        makeOutlets()
        layoutOutlets()
        unhighlight()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func highlight() {
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.alpha = 0.3
            self?.layer.shadowOpacity = 0
        }
    }
    
    func unhighlight() {
        UIView.animate(withDuration:0.3) { [weak self] in
            self?.alpha = 1
            self?.layer.shadowOpacity = 0.12
        }
    }
    
    private func makeOutlets() {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isUserInteractionEnabled = false
        name.font = .systemFont(ofSize:12, weight:.bold)
        name.textColor = .black
        addSubview(name)
        self.name = name
        
        let progress = ProgressView()
        progress.lineWidth = 3
        addSubview(progress)
        self.progress = progress
    }
    
    private func layoutOutlets() {
        name.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:progress.rightAnchor).isActive = true
        
        progress.topAnchor.constraint(equalTo:topAnchor, constant:6).isActive = true
        progress.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-6).isActive = true
        progress.leftAnchor.constraint(equalTo:leftAnchor, constant:4).isActive = true
        progress.widthAnchor.constraint(equalToConstant:42).isActive = true
    }
}
