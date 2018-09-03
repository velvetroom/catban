import UIKit

class TodayCellView:UIControl {
    let item:LibraryItem
    
    init(item:LibraryItem) {
        self.item = item
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        makeOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    @objc func highlight() { alpha = 0.1 }
    @objc func unhighlight() { alpha = 1 }
    
    private func makeOutlets() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize:11, weight:.light)
        label.textColor = .black
        label.textAlignment = .center
        label.text = item.name
        addSubview(label)
        
        let progress = LibraryProgress()
        progress.tintColor = .black
        progress.progress = CGFloat(item.progress)
        addSubview(progress)
        
        label.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-12).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor, constant:6).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor, constant:-6).isActive = true
        
        progress.topAnchor.constraint(equalTo:topAnchor).isActive = true
        progress.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        progress.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        progress.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
}
