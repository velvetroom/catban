import UIKit
import CleanArchitecture
import MarkdownHero

class SettingsView:View<SettingsPresenter> {
    weak var scroll:UIScrollView!
    weak var content:UIView!
    weak var columns:UIView!
    weak var font:UIView!
    weak var labelColumns:UILabel!
    weak var labelFont:UILabel!
    weak var displayFont:UILabel!
    weak var columnsSwitch:UISwitch!
    weak var fontSlider:UISlider!
    private let parser = Parser()
    
    override func viewDidLoad() {
        makeOutlets()
        layoutOutlets()
        configureViewModel()
        super.viewDidLoad()
        view.backgroundColor = UIColor(white:0.94, alpha:1)
        title = NSLocalizedString("SettingsView.title", comment:String())
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        update(width:view.bounds.width)
    }
    
    override func viewWillTransition(to size:CGSize, with coordinator:UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        update(width:size.width)
    }
    
    private func makeOutlets() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .clear
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        view.addSubview(scroll)
        self.scroll = scroll
        
        let content = UIView()
        content.clipsToBounds = false
        scroll.addSubview(content)
        self.content = content
        
        let columns = UIView()
        columns.backgroundColor = .white
        columns.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(columns)
        self.columns = columns
        
        let font = UIView()
        font.backgroundColor = .white
        font.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(font)
        self.font = font
        
        let labelColumns = UILabel()
        labelColumns.translatesAutoresizingMaskIntoConstraints = false
        labelColumns.isUserInteractionEnabled = false
        labelColumns.textColor = .black
        labelColumns.numberOfLines = 0
        columns.addSubview(labelColumns)
        self.labelColumns = labelColumns
        
        let columnsSwitch = UISwitch()
        columnsSwitch.translatesAutoresizingMaskIntoConstraints = false
        columnsSwitch.onTintColor = #colorLiteral(red: 0.2349999994, green: 0.7220000029, blue: 1, alpha: 1)
        columnsSwitch.addTarget(self, action:#selector(updateColumns), for:.valueChanged)
        columns.addSubview(columnsSwitch)
        self.columnsSwitch = columnsSwitch
        
        let labelFont = UILabel()
        labelFont.translatesAutoresizingMaskIntoConstraints = false
        labelFont.isUserInteractionEnabled = false
        labelFont.textColor = .black
        labelFont.numberOfLines = 0
        font.addSubview(labelFont)
        self.labelFont = labelFont
        
        let fontSlider = UISlider()
        fontSlider.tintColor = #colorLiteral(red: 0.2349999994, green: 0.7220000029, blue: 1, alpha: 1)
        fontSlider.translatesAutoresizingMaskIntoConstraints = false
        fontSlider.minimumValue = 8
        fontSlider.maximumValue = 30
        fontSlider.addTarget(self, action:#selector(updateFont), for:.valueChanged)
        font.addSubview(fontSlider)
        self.fontSlider = fontSlider
        
        let displayFont = UILabel()
        displayFont.translatesAutoresizingMaskIntoConstraints = false
        displayFont.textColor = .black
        displayFont.isUserInteractionEnabled = false
        displayFont.textAlignment = .right
        font.addSubview(displayFont)
        self.displayFont = displayFont

        parser.parse(string:NSLocalizedString("SettingsView.labelColumns", comment:String())) { [weak self] result in
            self?.labelColumns.attributedText = result
        }
        parser.parse(string:NSLocalizedString("SettingsView.labelFont", comment:String())) { [weak self] result in
            self?.labelFont.attributedText = result
        }
    }
    
    private func layoutOutlets() {
        scroll.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        columns.topAnchor.constraint(equalTo:content.topAnchor).isActive = true
        columns.heightAnchor.constraint(equalToConstant:115).isActive = true
        columns.leftAnchor.constraint(equalTo:content.leftAnchor).isActive = true
        columns.rightAnchor.constraint(equalTo:content.rightAnchor).isActive = true
        
        font.topAnchor.constraint(equalTo:columns.bottomAnchor, constant:1).isActive = true
        font.heightAnchor.constraint(equalToConstant:120).isActive = true
        font.leftAnchor.constraint(equalTo:content.leftAnchor).isActive = true
        font.rightAnchor.constraint(equalTo:content.rightAnchor).isActive = true
        
        labelColumns.topAnchor.constraint(equalTo:columns.topAnchor, constant:17).isActive = true
        labelColumns.leftAnchor.constraint(equalTo:columns.leftAnchor, constant:17).isActive = true
        labelColumns.rightAnchor.constraint(equalTo:columnsSwitch.leftAnchor, constant:-17).isActive = true
        
        columnsSwitch.topAnchor.constraint(equalTo:columns.topAnchor, constant:17).isActive = true
        columnsSwitch.rightAnchor.constraint(equalTo:columns.rightAnchor, constant:-17).isActive = true
        columnsSwitch.widthAnchor.constraint(equalToConstant:44).isActive = true
        
        labelFont.topAnchor.constraint(equalTo:font.topAnchor, constant:17).isActive = true
        labelFont.leftAnchor.constraint(equalTo:font.leftAnchor, constant:17).isActive = true
        
        fontSlider.bottomAnchor.constraint(equalTo:font.bottomAnchor, constant:-17).isActive = true
        fontSlider.leftAnchor.constraint(equalTo:font.leftAnchor, constant:17).isActive = true
        fontSlider.rightAnchor.constraint(equalTo:font.rightAnchor, constant:-17).isActive = true
        
        displayFont.topAnchor.constraint(equalTo:font.topAnchor, constant:17).isActive = true
        displayFont.rightAnchor.constraint(equalTo:font.rightAnchor, constant:-17).isActive = true
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            scroll.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            scroll.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    private func configureViewModel() {
        presenter.viewModels.observe { [weak self] (viewModel:SettingsViewModel) in
            self?.updateDisplay(size:viewModel.cardsFont)
            self?.fontSlider.setValue(Float(viewModel.cardsFont), animated:false)
            self?.columnsSwitch.isOn = viewModel.defaultColumns
        }
    }
    
    private func update(width:CGFloat) {
        scroll.contentSize = CGSize(width:width, height:236)
        content.frame = CGRect(origin:.zero, size:scroll.contentSize)
    }
    
    @objc private func updateFont() {
        let size = Int(fontSlider.value)
        presenter.update(cardsFont:size)
        updateDisplay(size:size)
    }
    
    @objc private func updateColumns() {
        presenter.update(defaultColumns:columnsSwitch.isOn)
    }
    
    private func updateDisplay(size:Int) {
        displayFont.font = .systemFont(ofSize:CGFloat(size), weight:.bold)
        displayFont.text = String(size)
    }
}
