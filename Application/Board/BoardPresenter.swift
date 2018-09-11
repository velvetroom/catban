import UIKit
import CleanArchitecture
import Catban

class BoardPresenter:Presenter<BoardInteractor> {
    private(set) var state:BoardState = BoardStateDefault()
    
    func detach(item:BoardCardView) {
        interactor.detach(card:item.card, column:item.column)
        item.column = nil
    }
    
    func attach(item:BoardCardView, after:BoardItemView) {
        interactor.attach(card:item.card, column:after.column, after:after.card)
        item.column = after.column
    }
    
    func delete() {
        interactor.delete()
    }
    
    @objc func edit() {
        interactor.edit()
    }
    
    @objc func info() {
        Application.router.dismiss(animated:false)
        interactor.info()
    }
    
    @objc func share() {
        Application.router.dismiss(animated:false)
        interactor.share()
    }
    
    @objc func newColumn() {
        interactor.newColumn()
    }
    
    @objc func editColumn(view:BoardItemView) {
        interactor.editColumn(column:view.column!)
    }
    
    @objc func newCard(view:BoardItemView) {
        interactor.newCard(column:view.column!)
    }
    
    @objc func editCard(view:BoardCardView) {
        interactor.editCard(column:view.column!, card:view.card!)
    }
    
    func search(text:String) {
        state = BoardStateSearch(text:text)
        update(viewModel:interactor.board.name)
    }
    
    func clearSearch() {
        state = BoardStateDefault()
        update(viewModel:interactor.board.name)
    }
    
    func updateProgress() {
        DispatchQueue.global(qos:.background).async { [weak self] in
            guard let stats = self?.interactor.makeStats() else { return }
            var previous = (-CGFloat.pi / 2) + 0.075
            var progress = [(CGFloat, CGFloat)]()
            let max = (CGFloat.pi * 2) + (previous - 0.15)
            stats.columns.forEach{ stat in
                if stat > 0 {
                    var next = previous + (CGFloat(stat) / CGFloat(stats.cards) * (CGFloat.pi * 2))
                    if next > max {
                        next = max
                    }
                    progress.append((previous, next))
                    previous = next + 0.15
                    if previous > max {
                        previous = max
                    }
                }
            }
            self?.update(viewModel:stats.progress)
            self?.update(viewModel:progress)
        }
    }
    
    override func didAppear() {
        update(viewModel:interactor.board.name)
        updateProgress()
    }
}
