import Foundation
import CleanArchitecture

class ScanPresenter:Presenter {
    weak var interactor:LibraryInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    @objc func cancel() {
        Application.router.dismiss(animated:true, completion:nil)
    }
    
    func read(string:String) {
        let components:[String] = string.components(separatedBy:ShareConstants.prefix)
        if components.count == 2 && !components[1].isEmpty {
            let identifier:String = components[1]
            self.show(message:NSLocalizedString("ScanPresenter.success", comment:String()), icon:#imageLiteral(resourceName: "assetValid.pdf"))
        } else {
            self.show(message:NSLocalizedString("ScanPresenter.error", comment:String()), icon:#imageLiteral(resourceName: "assetError.pdf"))
        }
    }
    
    func didLoad() {
        var viewModel:ScanViewModel = ScanViewModel()
        viewModel.alphaCamera = 1.0
        self.viewModels.update(viewModel:viewModel)
    }
    
    private func show(message:String, icon:UIImage) {
        var viewModel:ScanViewModel = ScanViewModel()
        viewModel.alphaMessage = 1.0
        viewModel.text = message
        viewModel.icon = icon
        self.viewModels.update(viewModel:viewModel)
    }
}
