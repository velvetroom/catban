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
    private let parser:Parser
    
    required init() {
        self.parser = Parser()
        super.init()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        self.makeOutlets()
        self.layoutOutlets()
        self.configureViewModel()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white:0.94, alpha:1.0)
        self.title = NSLocalizedString("SettingsView.title", comment:String())
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        self.update(width:self.view.bounds.width)
    }
    
    override func viewWillTransition(to size:CGSize, with coordinator:UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        self.update(width:size.width)
    }
    
    private func makeOutlets() {
        let scroll:UIScrollView = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.clear
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        self.scroll = scroll
        self.view.addSubview(scroll)
        
        let content:UIView = UIView()
        content.clipsToBounds = false
        self.content = content
        self.scroll.addSubview(content)
        
        let columns:UIView = UIView()
        columns.backgroundColor = UIColor.white
        columns.translatesAutoresizingMaskIntoConstraints = false
        self.columns = columns
        self.content.addSubview(columns)
        
        let font:UIView = UIView()
        font.backgroundColor = UIColor.white
        font.translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        self.content.addSubview(font)
        
        let labelColumns:UILabel = UILabel()
        labelColumns.translatesAutoresizingMaskIntoConstraints = false
        labelColumns.isUserInteractionEnabled = false
        labelColumns.textColor = UIColor.black
        labelColumns.numberOfLines = 0
        self.labelColumns = labelColumns
        self.columns.addSubview(labelColumns)
        
        let columnsSwitch:UISwitch = UISwitch()
        columnsSwitch.translatesAutoresizingMaskIntoConstraints = false
        columnsSwitch.onTintColor = #colorLiteral(red: 0.2349999994, green: 0.7220000029, blue: 1, alpha: 1)
        self.columnsSwitch = columnsSwitch
        self.columns.addSubview(columnsSwitch)
        
        let labelFont:UILabel = UILabel()
        labelFont.translatesAutoresizingMaskIntoConstraints = false
        labelFont.isUserInteractionEnabled = false
        labelFont.textColor = UIColor.black
        labelFont.numberOfLines = 0
        self.labelFont = labelFont
        self.font.addSubview(labelFont)
        
        let fontSlider:UISlider = UISlider()
        fontSlider.tintColor = #colorLiteral(red: 0.2349999994, green: 0.7220000029, blue: 1, alpha: 1)
        fontSlider.translatesAutoresizingMaskIntoConstraints = false
        fontSlider.minimumValue = Constants.minFont
        fontSlider.maximumValue = Constants.maxFont
        fontSlider.addTarget(self, action:#selector(self.updateFont), for:UIControl.Event.valueChanged)
        self.fontSlider = fontSlider
        self.font.addSubview(fontSlider)
        
        let displayFont:UILabel = UILabel()
        displayFont.translatesAutoresizingMaskIntoConstraints = false
        displayFont.textColor = UIColor.black
        displayFont.isUserInteractionEnabled = false
        displayFont.textAlignment = NSTextAlignment.right
        self.displayFont = displayFont
        self.font.addSubview(displayFont)

        self.parser.parse(string:NSLocalizedString("SettingsView.labelColumns", comment:String()))
        { [weak self] (result:NSAttributedString) in
            self?.labelColumns.attributedText = result
        }
        
        self.parser.parse(string:NSLocalizedString("SettingsView.labelFont", comment:String()))
        { [weak self] (result:NSAttributedString) in
            self?.labelFont.attributedText = result
        }
    }
    
    private func layoutOutlets() {
        self.scroll.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.scroll.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        self.scroll.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
        
        self.columns.topAnchor.constraint(equalTo:self.content.topAnchor).isActive = true
        self.columns.heightAnchor.constraint(equalToConstant:Constants.columnsHeight).isActive = true
        self.columns.leftAnchor.constraint(equalTo:self.content.leftAnchor).isActive = true
        self.columns.rightAnchor.constraint(equalTo:self.content.rightAnchor).isActive = true
        
        self.font.topAnchor.constraint(equalTo:self.columns.bottomAnchor, constant:Constants.spacing).isActive = true
        self.font.heightAnchor.constraint(equalToConstant:Constants.fontHeight).isActive = true
        self.font.leftAnchor.constraint(equalTo:self.content.leftAnchor).isActive = true
        self.font.rightAnchor.constraint(equalTo:self.content.rightAnchor).isActive = true
        
        self.labelColumns.topAnchor.constraint(equalTo:self.columns.topAnchor,
                                               constant:Constants.margin).isActive = true
        self.labelColumns.leftAnchor.constraint(equalTo:self.columns.leftAnchor,
                                                constant:Constants.margin).isActive = true
        self.labelColumns.rightAnchor.constraint(equalTo:self.columnsSwitch.leftAnchor,
                                                 constant:-Constants.margin).isActive = true
        
        self.columnsSwitch.topAnchor.constraint(equalTo:self.columns.topAnchor,
                                                constant:Constants.margin).isActive = true
        self.columnsSwitch.rightAnchor.constraint(equalTo:self.columns.rightAnchor,
                                                constant:-Constants.margin).isActive = true
        self.columnsSwitch.widthAnchor.constraint(equalToConstant:Constants.switchWidth).isActive = true
        
        self.labelFont.topAnchor.constraint(equalTo:self.font.topAnchor,
                                               constant:Constants.margin).isActive = true
        self.labelFont.leftAnchor.constraint(equalTo:self.font.leftAnchor,
                                                constant:Constants.margin).isActive = true
        
        self.fontSlider.bottomAnchor.constraint(equalTo:self.font.bottomAnchor,
                                                constant:-Constants.margin).isActive = true
        self.fontSlider.leftAnchor.constraint(equalTo:self.font.leftAnchor,
                                              constant:Constants.margin).isActive = true
        self.fontSlider.rightAnchor.constraint(equalTo:self.font.rightAnchor,
                                               constant:-Constants.margin).isActive = true
        
        self.displayFont.topAnchor.constraint(equalTo:self.font.topAnchor, constant:Constants.margin).isActive = true
        self.displayFont.rightAnchor.constraint(equalTo:self.font.rightAnchor,
                                                constant:-Constants.margin).isActive = true
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
            self.scroll.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            self.scroll.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
        }
    }
    
    private func configureViewModel() {
        
    }
    
    private func update(width:CGFloat) {
        self.scroll.contentSize = CGSize(width:width, height:Constants.columnsHeight + Constants.spacing +
            Constants.fontHeight)
        self.content.frame = CGRect(origin:CGPoint.zero, size:self.scroll.contentSize)
    }
    
    @objc private func updateFont() {
        let size:Int = Int(self.fontSlider.value)
        self.updateDisplay(size:size)
    }
    
    private func updateDisplay(size:Int) {
        self.displayFont.font = UIFont.systemFont(ofSize:CGFloat(size), weight:UIFont.Weight.bold)
        self.displayFont.text = String(size)
    }
}

private struct Constants {
    static let columnsHeight:CGFloat = 115.0
    static let fontHeight:CGFloat = 120.0
    static let spacing:CGFloat = 1.0
    static let margin:CGFloat = 17.0
    static let switchWidth:CGFloat = 50.0
    static let minFont:Float = 8.0
    static let maxFont:Float = 30.0
}
