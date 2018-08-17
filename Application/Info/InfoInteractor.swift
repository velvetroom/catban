import Foundation
import CleanArchitecture

protocol InfoInteractor:Interactor {
    func dismiss()
}

extension InfoInteractor {
    func dismiss() {
        Application.router.dismiss(animated:true, completion:nil)
    }
}
