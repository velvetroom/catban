import UIKit
import CleanArchitecture
import Catban

class BoardPresenter:Presenter {
    var interactor:BoardInteractor!
    var viewModels:ViewModels!
    private(set) var state:BoardState
    
    required init() {
        self.state = BoardStateDefault()
    }
    
    func detach(item:BoardCardView) {
        self.interactor.detach(card:item.card, column:item.column)
        item.column = nil
    }
    
    func attach(item:BoardCardView, after:BoardItemView) {
        self.interactor.attach(card:item.card, column:after.column, after:after.card)
        item.column = after.column
    }
    
    @objc func edit() {
        self.interactor.edit()
    }
    
    @objc func info() {
        self.interactor.info()
    }
    
    @objc func share() {
        self.interactor.share()
    }
    
    @objc func newColumn() {
        self.interactor.newColumn()
    }
    
    @objc func editColumn(view:BoardItemView) {
        self.interactor.editColumn(column:view.column!)
    }
    
    @objc func newCard(view:BoardItemView) {
        self.interactor.newCard(column:view.column!)
    }
    
    @objc func editCard(view:BoardCardView) {
        self.interactor.editCard(column:view.column!, card:view.card!)
    }
    
    func search(text:String) {
        self.state = BoardStateSearch(text:text)
        self.updateViewModel()
    }
    
    func clearSearch() {
        self.state = BoardStateDefault()
        self.updateViewModel()
    }
    
    func updateProgress() {
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async { [weak self] in
            guard let stats:ReportStats = self?.interactor.makeStats() else { return }
            var viewModel:BoardProgressViewModel = BoardProgressViewModel()
            viewModel.progress = stats.progress
            viewModel.columns = stats.columns
            self?.viewModels.update(viewModel:viewModel)
        }
    }
    
    func didAppear() {
        self.updateViewModel()
        self.updateProgress()
    }
    
    private func updateViewModel() {
        var viewModel:BoardViewModel = BoardViewModel()
        viewModel.title = self.interactor.board.text
        self.viewModels.update(viewModel:viewModel)
    }
}
