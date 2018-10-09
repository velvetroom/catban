import CleanArchitecture
import MarkdownHero
import MessageUI

class SettingsView:View<SettingsPresenter>, MFMailComposeViewControllerDelegate {
    private weak var scroll:UIScrollView!
    private weak var content:UIView!
    private weak var columnsSwitch:UISwitch!
    private weak var fontSlider:UISlider!
    private weak var displayFont:UILabel!
    private let hero = Hero()
    private let url = "itunes.apple.com/\(Locale.current.regionCode!.lowercased())/app/catban/id1363004864"
    
    override func viewDidLoad() {
        makeOutlets()
        configureViewModel()
        super.viewDidLoad()
        view.backgroundColor = .white
        title = .local("SettingsView.title")
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        update(width:view.bounds.width)
    }
    
    override func viewWillTransition(to size:CGSize, with coordinator:UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        update(width:size.width)
    }
    
    func mailComposeController(_:MFMailComposeViewController, didFinishWith:MFMailComposeResult, error:Error?) {
        Application.navigation.dismiss(animated:true)
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
        
        let about = UIView()
        about.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(about)
        
        let columns = UIView()
        columns.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(columns)
        
        let font = UIView()
        font.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(font)
        
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = false
        icon.clipsToBounds = true
        icon.image = #imageLiteral(resourceName: "assetLogoSmall.pdf")
        icon.contentMode = .center
        about.addSubview(icon)
        
        let labelAbout = UILabel()
        labelAbout.translatesAutoresizingMaskIntoConstraints = false
        labelAbout.isUserInteractionEnabled = false
        labelAbout.textColor = .black
        labelAbout.textAlignment = .center
        labelAbout.numberOfLines = 0
        labelAbout.text = String(format:.local("SettingsView.labelAbout"),
            "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)")
        labelAbout.font = .systemFont(ofSize:12, weight:.ultraLight)
        about.addSubview(labelAbout)
        
        let contact = UIButton()
        contact.translatesAutoresizingMaskIntoConstraints = false
        contact.setTitle(.local("SettingsView.contact"), for:[])
        contact.setTitleColor(.black, for:.normal)
        contact.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        contact.titleLabel!.font = .systemFont(ofSize:14, weight:.light)
        contact.addTarget(self, action:#selector(email), for:.touchUpInside)
        about.addSubview(contact)
        
        let share = UIButton()
        share.translatesAutoresizingMaskIntoConstraints = false
        share.setTitle(.local("SettingsView.share"), for:[])
        share.setTitleColor(.black, for:.normal)
        share.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        share.titleLabel!.font = .systemFont(ofSize:14, weight:.light)
        share.addTarget(self, action:#selector(shareUrl), for:.touchUpInside)
        about.addSubview(share)
        
        let review = UIButton()
        review.translatesAutoresizingMaskIntoConstraints = false
        review.setTitle(.local("SettingsView.review"), for:[])
        review.setTitleColor(.black, for:.normal)
        review.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        review.titleLabel!.font = .systemFont(ofSize:14, weight:.light)
        review.addTarget(self, action:#selector(reviewUrl), for:.touchUpInside)
        about.addSubview(review)
        
        let separatorLeft = UIView()
        separatorLeft.translatesAutoresizingMaskIntoConstraints = false
        separatorLeft.isUserInteractionEnabled = false
        separatorLeft.backgroundColor = UIColor(white:0, alpha:0.2)
        about.addSubview(separatorLeft)
        
        let separatorRight = UIView()
        separatorRight.translatesAutoresizingMaskIntoConstraints = false
        separatorRight.isUserInteractionEnabled = false
        separatorRight.backgroundColor = UIColor(white:0, alpha:0.2)
        about.addSubview(separatorRight)
        
        let labelColumns = UILabel()
        labelColumns.translatesAutoresizingMaskIntoConstraints = false
        labelColumns.isUserInteractionEnabled = false
        labelColumns.textColor = .black
        labelColumns.numberOfLines = 0
        columns.addSubview(labelColumns)
        
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

        hero.parse(string:.local("SettingsView.labelColumns")) { result in
            labelColumns.attributedText = result
        }
        hero.parse(string:.local("SettingsView.labelFont")) { result in
            labelFont.attributedText = result
        }
        
        scroll.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        about.topAnchor.constraint(equalTo:content.topAnchor).isActive = true
        about.heightAnchor.constraint(equalToConstant:330).isActive = true
        about.leftAnchor.constraint(equalTo:content.leftAnchor).isActive = true
        about.rightAnchor.constraint(equalTo:content.rightAnchor).isActive = true
        
        columns.topAnchor.constraint(equalTo:about.bottomAnchor).isActive = true
        columns.heightAnchor.constraint(equalToConstant:130).isActive = true
        columns.leftAnchor.constraint(equalTo:content.leftAnchor).isActive = true
        columns.rightAnchor.constraint(equalTo:content.rightAnchor).isActive = true
        
        font.topAnchor.constraint(equalTo:columns.bottomAnchor).isActive = true
        font.heightAnchor.constraint(equalToConstant:120).isActive = true
        font.leftAnchor.constraint(equalTo:content.leftAnchor).isActive = true
        font.rightAnchor.constraint(equalTo:content.rightAnchor).isActive = true
        
        icon.topAnchor.constraint(equalTo:about.topAnchor, constant:60).isActive = true
        icon.centerXAnchor.constraint(equalTo:about.centerXAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant:50).isActive = true
        icon.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        labelAbout.centerXAnchor.constraint(equalTo:icon.centerXAnchor).isActive = true
        labelAbout.topAnchor.constraint(equalTo:icon.bottomAnchor, constant:6).isActive = true
        
        contact.centerXAnchor.constraint(equalTo:about.centerXAnchor).isActive = true
        contact.topAnchor.constraint(equalTo:labelAbout.bottomAnchor, constant:80).isActive = true
        contact.widthAnchor.constraint(equalToConstant:105).isActive = true
        contact.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        share.rightAnchor.constraint(equalTo:contact.leftAnchor).isActive = true
        share.topAnchor.constraint(equalTo:contact.topAnchor).isActive = true
        share.widthAnchor.constraint(equalTo:contact.widthAnchor).isActive = true
        share.heightAnchor.constraint(equalTo:contact.heightAnchor).isActive = true
        
        review.leftAnchor.constraint(equalTo:contact.rightAnchor).isActive = true
        review.topAnchor.constraint(equalTo:contact.topAnchor).isActive = true
        review.widthAnchor.constraint(equalTo:contact.widthAnchor).isActive = true
        review.heightAnchor.constraint(equalTo:contact.heightAnchor).isActive = true
        
        separatorLeft.centerYAnchor.constraint(equalTo:contact.centerYAnchor).isActive = true
        separatorLeft.rightAnchor.constraint(equalTo:contact.leftAnchor).isActive = true
        separatorLeft.widthAnchor.constraint(equalToConstant:1).isActive = true
        separatorLeft.heightAnchor.constraint(equalToConstant:14).isActive = true
        
        separatorRight.centerYAnchor.constraint(equalTo:contact.centerYAnchor).isActive = true
        separatorRight.leftAnchor.constraint(equalTo:contact.rightAnchor).isActive = true
        separatorRight.widthAnchor.constraint(equalToConstant:1).isActive = true
        separatorRight.heightAnchor.constraint(equalToConstant:14).isActive = true
        
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
        presenter.viewModel { [weak self] (viewModel:SettingsViewModel) in
            self?.updateDisplay(size:viewModel.cardsFont)
            self?.fontSlider.setValue(Float(viewModel.cardsFont), animated:false)
            self?.columnsSwitch.isOn = viewModel.defaultColumns
        }
    }
    
    private func update(width:CGFloat) {
        scroll.contentSize = CGSize(width:width, height:580)
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
    
    @objc private func email() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["catban@iturbi.de"])
            mail.setSubject(.local("SettingsView.sendEmailSubject"))
            mail.setMessageBody(.local("SettingsView.sendEmailBody"), isHTML:false)
            Application.navigation.present(mail, animated:true)
        } else {
            let alert = Alert()
            alert.title = .local("SettingsView.sendEmailFailed")
            alert.image = #imageLiteral(resourceName: "assetError.pdf")
        }
    }
    
    @objc private func shareUrl() {
        let view = UIActivityViewController(activityItems:[URL(string:"https://\(url)")!], applicationActivities:nil)
        if let popover = view.popoverPresentationController {
            popover.sourceView = content
            popover.sourceRect = .zero
            popover.permittedArrowDirections = .any
        }
        Application.navigation.present(view, animated:true)
    }
    
    @objc private func reviewUrl() {
        UIApplication.shared.openURL(URL(string:"itms-apps://\(url)")!)
    }
    
    private func updateDisplay(size:Int) {
        displayFont.font = .systemFont(ofSize:CGFloat(size), weight:.bold)
        displayFont.text = String(size)
    }
}
