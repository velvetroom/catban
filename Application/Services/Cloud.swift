import Foundation

class Cloud {
    deinit { NotificationCenter.default.removeObserver(self) }
    
    func synchronize() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector:#selector(changeExternally), name:
            NSUbiquitousKeyValueStore.didChangeExternallyNotification, object:NSUbiquitousKeyValueStore.default)
        NSUbiquitousKeyValueStore.default.synchronize()
    }
    
    @objc private func changeExternally(notification:Notification) {
        print("user info")
        print(notification.userInfo)
    }
}
