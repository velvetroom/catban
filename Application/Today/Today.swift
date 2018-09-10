import Foundation

struct Today:Codable {
    static func retrieve() -> Today? {
        var today:Today?
        if let data = UserDefaults(suiteName:"group.Catban")?.data(forKey:"today") {
            today = try? JSONDecoder().decode(Today.self, from:data)
        }
        return today
    }
    
    let items:[LibraryItem]
    init(items:[LibraryItem]) { self.items = Array(items.prefix(4)) }
    private init() { items = [] }
    
    func store() {
        let store = UserDefaults(suiteName:"group.Catban")
        if let data = try? JSONEncoder().encode(self) {
            store?.set(data, forKey:"today")
        }
        store?.synchronize()
    }
}
