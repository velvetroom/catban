import Foundation
import CleanArchitecture

class DeletePresenter:Presenter {
    var interactor:DeleteInteractor!
    var viewModels:ViewModels!
    
    required init() { }
    
    @objc func cancel() {
        self.interactor.cancel()
    }
    
    @objc func delete() {
        self.interactor.delete()
    }
    
    func didLoad() {
        let viewModel:DeleteViewModel = DeleteViewModel()
        viewModel.message.append(NSAttributedString(
            string:NSLocalizedString("DeletePresenter.message", comment:String()), attributes:
            [NSAttributedString.Key.font:UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.medium)]))
        viewModel.message.append(NSAttributedString(
            string:self.interactor.board.text, attributes:
            [NSAttributedString.Key.font:UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.light)]))
        self.viewModels.update(viewModel:viewModel)
    }
}

private struct Constants {
    static let font:CGFloat = 18.0
}
