import UIKit

class LibraryCellView:UIControl {
    weak var name:UILabel!
    weak var progress:UIProgressView!
    var viewModel:LibraryItem! { didSet {
        name.text = viewModel.name
        let progress = viewModel.progress
        DispatchQueue.main.async { [weak self] in self?.progress.setProgress(progress, animated:true) }
    } }
    
    init() {
        super.init(frame:.zero)
        makeOutlets()
        layoutOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func highlight() {
        backgroundColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
    }
    
    func unhighlight() {
        backgroundColor = .clear
    }
    
    private func makeOutlets() {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isUserInteractionEnabled = false
        name.font = UIFont.systemFont(ofSize:13, weight:.light)
        name.textColor = .black
        addSubview(name)
        self.name = name
        
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.isUserInteractionEnabled = false
        progress.progressTintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        progress.trackTintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1).withAlphaComponent(0.1)
        addSubview(progress)
        self.progress = progress
    }
    
    private func layoutOutlets() {
        name.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        
        progress.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        progress.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        progress.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        progress.heightAnchor.constraint(equalToConstant:5).isActive = true
    }
}
