import Foundation

class Today:Codable {
    private static let store = UserDefaults(suiteName:"group.Catban")!
    
    class func retrieve() -> Today? {
        var today:Today?
        if let data = store.data(forKey:"today") {
            today = try? JSONDecoder().decode(Today.self, from:data)
        }
        return today
    }
    
    let items:[LibraryItem]
    init(items:[LibraryItem]) { self.items = Array(items.prefix(4)) }
    private init() { items = [] }
    
    func store() {
        Today.store.set(try! JSONEncoder().encode(self), forKey:"today")
        Today.store.synchronize()
    }
}
