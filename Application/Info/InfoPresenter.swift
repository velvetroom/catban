import Foundation
import CleanArchitecture
import MarkdownHero

class InfoPresenter:Presenter<BoardInteractor> {
    var source = String()
    private var parser = Parser()
    
    @objc func dismiss() {
        Application.router.dismiss(animated:true)
    }
    
    override func didLoad() {
        DispatchQueue.global(qos:.background).async { [weak self] in self?.loadInfo() }
    }
    
    private func loadInfo() {
        let url = Bundle.main.url(forResource:source, withExtension:"md")!
        if let string = try? String(contentsOf:url, encoding:.utf8) {
            update(viewModel:parser.parse(string:string))
        }
    }
}
