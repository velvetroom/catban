import Foundation
import CleanArchitecture
import MarkdownHero

class InfoPresenter<I:InfoInteractor>:Presenter {
    var interactor:I!
    var viewModels:ViewModels!
    var source:String
    private var parser:Parser
    
    required init() {
        self.source = String()
        self.parser = Parser()
    }
    
    @objc func dismiss() {
        self.interactor.dismiss()
    }
    
    func didLoad() {
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async { [weak self] in self?.loadInfo() }
    }
    
    private func loadInfo() {
        let url:URL = Bundle(for:InfoPresenter.self).url(forResource:self.source, withExtension:Constants.file)!
        let string:String
        do { try string = String(contentsOf:url, encoding:String.Encoding.utf8) } catch { return }
        var viewModel:InfoViewModel = InfoViewModel()
        viewModel.text = self.parser.parse(string:string)
        self.viewModels.update(viewModel:viewModel)
    }
}

private struct Constants {
    static let file:String = "md"
}
