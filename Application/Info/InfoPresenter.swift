import Foundation
import CleanArchitecture
import MarkdownHero

class InfoPresenter<I:InfoInteractor>:Presenter {
    var interactor:I!
    var viewModels:ViewModels!
    var source:String
    private var parser:Parser
    
    required init() {
        source = String()
        parser = Parser()
    }
    
    @objc func dismiss() {
        interactor.dismiss()
    }
    
    func didLoad() {
        DispatchQueue.global(qos:.background).async { [weak self] in self?.loadInfo() }
    }
    
    private func loadInfo() {
        let url = Bundle.main.url(forResource:source, withExtension:"md")!
        let string:String
        do { try string = String(contentsOf:url, encoding:.utf8) } catch { return }
        var viewModel = InfoViewModel()
        viewModel.text = parser.parse(string:string)
        viewModels.update(viewModel:viewModel)
    }
}
