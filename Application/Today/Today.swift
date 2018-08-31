import Foundation

struct Today:Codable {
    let date = Date()
    let items:[LibraryItem]
    
    init(items:[LibraryItem]) {
        self.items = items
    }
}
