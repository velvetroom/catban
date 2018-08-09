import UIKit
import CleanArchitecture

class SharePresenter:Presenter {
    weak var interactor:BoardInteractor!
    var viewModels:ViewModels!
    private let qr:Qr
    
    required init() {
        self.qr = Qr()
    }
    
    @objc func done() {
        Application.router.dismiss(animated:true, completion:nil)
    }
    
    func send(image:UIImage) {
        let view:UIActivityViewController = UIActivityViewController(activityItems:[image], applicationActivities:nil)
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
        self.qr.generate(message:ShareConstants.prefix + self.interactor.identifier) { [weak self] (image:UIImage) in
            var viewModel:ShareViewModel = ShareViewModel()
            viewModel.image = image
            self?.viewModels.update(viewModel:viewModel)
        }
    }
}

struct ShareConstants {
    static let prefix:String = "iturbide.catban."
}
