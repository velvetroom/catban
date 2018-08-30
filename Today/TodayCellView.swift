import UIKit

class TodayCellView:UIView {
    weak var label:UILabel!
    weak var progress:UIProgressView!
    
    init() {
        super.init(frame:.zero)
        makeOutlets()
        layoutOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    private func makeOutlets() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize:11, weight:.regular)
        label.textColor = UIColor.black
        addSubview(label)
        self.label = label
        
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.isUserInteractionEnabled = false
        progress.progressTintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1)
        progress.trackTintColor = #colorLiteral(red: 0.2380000055, green: 0.7220000029, blue: 1, alpha: 1).withAlphaComponent(0.1)
        addSubview(progress)
        self.progress = progress
    }
    
    private func layoutOutlets() {
        label.topAnchor.constraint(equalTo:topAnchor, constant:5).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor, constant:5).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor, constant:-5).isActive = true
        
        progress.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-5).isActive = true
        progress.leftAnchor.constraint(equalTo:leftAnchor, constant:5).isActive = true
        progress.rightAnchor.constraint(equalTo:rightAnchor, constant:-5).isActive = true
        progress.heightAnchor.constraint(equalToConstant:5).isActive = true
    }
}
