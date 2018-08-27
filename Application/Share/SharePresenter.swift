import UIKit
import CleanArchitecture
import QRhero

class SharePresenter:Presenter {
    weak var interactor:BoardInteractor!
    var viewModels:ViewModels!
    private let qrHero = QRhero()
    private static let top:CGFloat = 125
    private static let margin:CGFloat = 45
    private static let logo:CGFloat = 50
    private static let logoMargin:CGFloat = 20
    
    required init() { }
    
    @objc func done() {
        Application.router.dismiss(animated:true)
    }
    
    func send(image:UIImage) {
        guard let url = prepare(image:image) else { return }
        let view = UIActivityViewController(activityItems:[url], applicationActivities:nil)
        if let popover = view.popoverPresentationController {
            popover.sourceView = Application.router.view
            popover.sourceRect = .zero
            popover.permittedArrowDirections = .any
        }
        Application.router.dismiss(animated:true) {
            Application.router.present(view, animated:true)
        }
    }
    
    func didLoad() {
        qrHero.write(content:interactor.boardUrl) { [weak self] (image) in
            var viewModel = ShareViewModel()
            viewModel.image = image
            self?.viewModels.update(viewModel:viewModel)
        }
    }
    
    private func prepare(image:UIImage) -> URL? {
        guard
            let cg = image.cgImage,
            let image = decorate(code:cg)
        else { return nil }
        return temporalUrl(image:image)
    }
    
    private func decorate(code:CGImage) -> UIImage? {
        let size = CGSize(width:CGFloat(code.width) + SharePresenter.margin + SharePresenter.margin,
                          height:CGFloat(code.height) + SharePresenter.top + SharePresenter.margin)
        UIGraphicsBeginImageContext(size)
        writeName(code:code, size:size)
        UIGraphicsGetCurrentContext()!.translateBy(x:0, y:size.height)
        UIGraphicsGetCurrentContext()!.scaleBy(x:1, y:-1)
        drawLogo()
        draw(code:code)
        UIGraphicsEndImageContext()
        return UIImage(cgImage:UIGraphicsGetCurrentContext()!.makeImage()!)
    }
    
    private func writeName(code:CGImage, size:CGSize) {
        let rect = CGRect(x:SharePresenter.margin + SharePresenter.logo + SharePresenter.logoMargin, y:size.height -
            SharePresenter.logo - SharePresenter.logoMargin, width:CGFloat(code.width), height:SharePresenter.logo)
        NSAttributedString(string:interactor.board.text, attributes:[.font:UIFont.systemFont(ofSize:20, weight:.light),
                                                                     .foregroundColor:UIColor.black]).draw(in:rect)
    }
    
    private func drawLogo() {
        let rect = CGRect(x:SharePresenter.margin + 6.0, y:SharePresenter.margin, width:SharePresenter.logo,
                          height:SharePresenter.logo)
        UIGraphicsGetCurrentContext()!.draw(#imageLiteral(resourceName: "assetLogoSmall.pdf").cgImage!, in:rect)
    }
    
    private func draw(code:CGImage) {
        let rect = CGRect(x:SharePresenter.margin, y:SharePresenter.top, width:CGFloat(code.width),
                          height:CGFloat(code.height))
        UIGraphicsGetCurrentContext()!.draw(code, in:rect)
    }
    
    func temporalUrl(image:UIImage) -> URL? {
        let url = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("Catban.jpeg")
        do { try image.jpegData(compressionQuality:1)!.write(to:url, options:.atomicWrite) } catch { }
        return url
    }
}
