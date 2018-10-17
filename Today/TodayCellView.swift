import UIKit

class TodayCellView:UIControl {
    let item:LibraryItem
    
    init(item:LibraryItem) {
        self.item = item
        super.init(frame:.zero)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        makeOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    @objc func highlight() { alpha = 0.2 }
    @objc func unhighlight() { alpha = 1 }
    
    private func makeOutlets() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize:10, weight:.regular)
        label.textColor = .black
        label.textAlignment = .center
        label.text = item.name
        label.numberOfLines = 0
        addSubview(label)
        
        let progress = ProgressView()
        progress.value = CGFloat(item.progress)
        addSubview(progress)
        
        label.topAnchor.constraint(equalTo:progress.bottomAnchor, constant:4).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor, constant:8).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor, constant:-8).isActive = true
        
        progress.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        progress.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-34).isActive = true
        progress.leftAnchor.constraint(equalTo:leftAnchor, constant:16).isActive = true
        progress.rightAnchor.constraint(equalTo:rightAnchor, constant:-16).isActive = true
    }
}
