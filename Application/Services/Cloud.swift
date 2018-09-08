import Foundation

class Cloud {
    weak var interactor:LibraryInteractor?
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    func synchronize() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector:#selector(changeExternally), name:
            NSUbiquitousKeyValueStore.didChangeExternallyNotification, object:NSUbiquitousKeyValueStore.default)
        NSUbiquitousKeyValueStore.default.synchronize()
    }
    
    func saveUpdates() {
        guard let boards = interactor?.library.boards.keys else { return }
        NSUbiquitousKeyValueStore.default.set(Array(boards), forKey:"iturbide.catban.boards")
        print("saved")
        print(NSUbiquitousKeyValueStore.default.array(forKey:"iturbide.catban.boards"))
    }
    
    @objc private func changeExternally(notification:Notification) {
        print("user info")
        print(notification.userInfo)
    }
}
