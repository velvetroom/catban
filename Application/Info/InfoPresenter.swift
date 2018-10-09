import CleanArchitecture
import MarkdownHero

class InfoPresenter:Presenter {
    var source = String()
    private let hero = Hero()
    @objc func dismiss() { Application.navigation.dismiss(animated:true) }
    override func didLoad() { DispatchQueue.global(qos:.background).async { [weak self] in self?.loadInfo() } }
    private func loadInfo() {
        let url = Bundle.main.url(forResource:source, withExtension:"md")!
        if let string = try? String(contentsOf:url, encoding:.utf8) {
            update(viewModel:hero.parse(string:string))
        }
    }
}
