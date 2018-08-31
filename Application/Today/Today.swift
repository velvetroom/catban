import Foundation

struct Today:Codable {
    static func retrieve() -> Today? {
        var today:Today?
        if let data = UserDefaults(suiteName:"group.Catban")?.data(forKey:"today") {
            do { today = try JSONDecoder().decode(Today.self, from:data) } catch { }
        }
        return today
    }
    
    let items:[LibraryItem]
    init(items:[LibraryItem]) { self.items = Array(items.prefix(4)) }
    private init() { items = [] }
    
    func store() {
        let store = UserDefaults(suiteName:"group.Catban")
        do { store?.set(try JSONEncoder().encode(self), forKey:"today") } catch { return }
        store?.synchronize()
    }
}
