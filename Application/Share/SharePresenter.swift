import UIKit
import CleanArchitecture
import QRhero

class SharePresenter:Presenter {
    weak var interactor:BoardInteractor!
    var viewModels:ViewModels!
    private let qrHero:QRhero
    
    required init() {
        self.qrHero = QRhero()
    }
    
    @objc func done() {
        Application.router.dismiss(animated:true, completion:nil)
    }
    
    func send(image:UIImage) {
        guard let url:URL = self.prepare(image:image) else { return }
        let view:UIActivityViewController = UIActivityViewController(activityItems:[url], applicationActivities:nil)
        if let popover:UIPopoverPresentationController = view.popoverPresentationController {
            popover.sourceView = Application.router.view
            popover.sourceRect = CGRect.zero
            popover.permittedArrowDirections = UIPopoverArrowDirection.any
        }
        Application.router.dismiss(animated:true) {
            Application.router.present(view, animated:true, completion:nil)
        }
    }
    
    func didLoad() {
        qrHero.write(content:self.interactor.boardUrl) { [weak self] (image) in
            var viewModel:ShareViewModel = ShareViewModel()
            viewModel.image = image
            self?.viewModels.update(viewModel:viewModel)
        }
    }
    
    private func prepare(image:UIImage) -> URL? {
        guard
            let cg:CGImage = image.cgImage,
            let image:UIImage = self.decorate(code:cg)
        else { return nil }
        return self.temporalUrl(image:image)
    }
    
    private func decorate(code:CGImage) -> UIImage? {
        let size:CGSize = CGSize(
            width:CGFloat(code.width) + Constants.margin + Constants.margin,
            height:CGFloat(code.height) + Constants.top + Constants.margin)
        UIGraphicsBeginImageContext(size)
        var image:UIImage?
        if let context:CGContext = UIGraphicsGetCurrentContext() {
            NSAttributedString(string:self.interactor.board.text, attributes:[
                NSAttributedString.Key.font:UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.light),
                NSAttributedString.Key.foregroundColor:UIColor.black]).draw(in:
                CGRect(x:Constants.margin + Constants.logo + Constants.logoMargin,
                       y:size.height - Constants.logo - Constants.logoMargin,
                       width:CGFloat(code.width), height:Constants.logo))
            context.translateBy(x:0.0, y:size.height)
            context.scaleBy(x:1.0, y:-1.0)
            context.draw(#imageLiteral(resourceName: "assetLogoSmall.pdf").cgImage!, in:
                CGRect(x:Constants.margin + 6.0, y:Constants.margin, width:Constants.logo, height:Constants.logo))
            context.draw(code, in:CGRect(x:Constants.margin, y:Constants.top,
                                         width:CGFloat(code.width), height:CGFloat(code.height)))
            if let cg:CGImage = context.makeImage() {
                image = UIImage(cgImage:cg)
            }
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    func temporalUrl(image:UIImage) -> URL? {
        let url:URL = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent(Constants.name)
        if let data:Data = image.jpegData(compressionQuality:Constants.compression) {
            do {
                try data.write(to:url, options:Data.WritingOptions.atomicWrite)
                return url
            } catch { }
        }
        return nil
    }
}

private struct Constants {
    static let name:String = "Catban.jpeg"
    static let top:CGFloat = 125.0
    static let margin:CGFloat = 45.0
    static let compression:CGFloat = 1.0
    static let logo:CGFloat = 50.0
    static let logoMargin:CGFloat = 20.0
    static let font:CGFloat = 20.0
}

struct ShareConstants {
    static let prefix:String = "iturbide.catban."
}
