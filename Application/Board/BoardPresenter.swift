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
        Application.router.dismiss(animated:false)
        interactor.delete()
    }
    
    @objc func edit() {
        Application.router.dismiss(animated:false)
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
        Application.router.dismiss(animated:false)
        interactor.newColumn()
    }
    
    @objc func editColumn(view:BoardItemView) {
        Application.router.dismiss(animated:false)
        interactor.editColumn(column:view.column!)
    }
    
    @objc func newCard(view:BoardItemView) {
        Application.router.dismiss(animated:false)
        interactor.newCard(column:view.column!)
    }
    
    @objc func editCard(view:BoardCardView) {
        Application.router.dismiss(animated:false)
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
            self?.updateProgress(stats:stats)
        }
    }
    
    override func didAppear() {
        update(viewModel:interactor.board.name)
        updateProgress()
    }
    
    private func updateProgress(stats:ReportStats) {
        update(viewModel:stats.progress)
        update(viewModel:stack(stats:stats))
    }
    
    private func stack(stats:ReportStats) -> [(CGFloat, CGFloat)] {
        var previous = (-CGFloat.pi / 2) + 0.075
        var progress = [(CGFloat, CGFloat)]()
        let max = (CGFloat.pi * 2) + (previous - 0.15)
        stats.columns.reversed().forEach{ stat in
            let percent = CGFloat(stat) / CGFloat(stats.cards)
            if percent == 1 {
                progress.append((0.0001, 0))
            } else if percent == 0 {
                progress.append((previous, previous))
            } else {
                var next = previous + (percent * (CGFloat.pi * 2))
                next = min(next, max)
                progress.append((previous, next))
                previous = next + 0.15
                previous = min(previous, max)
            }
        }
        return progress
    }
}
