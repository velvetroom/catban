import Foundation
import Catban
import Firebase

class Database:DatabaseService {
    private let boards = Firestore.firestore().collection("Boards")
    
    required init() { }
    
    func load(identifier:String, board:@escaping((Board) -> Void), error:@escaping(() -> Void)) {
        boards.document(identifier).getDocument { [weak self] snapshot, _ in
            guard let json = snapshot?.data() else { return error() }
            self?.loaded(json:json, completion:board)
        }
    }
    
    func create(board:Board) -> String {
        return boards.addDocument(data:json(model:board)).documentID
    }
    
    func save(identifier:String, board:Board) {
        boards.document(identifier).setData(json(model:board))
    }
    
    private func loaded<M:Codable>(json:[String:Any], completion:@escaping((M) -> Void)) {
        do {
            completion(try JSONDecoder().decode(M.self, from:try JSONSerialization.data(withJSONObject:json)))
        } catch { }
    }
    
    private func json<M:Encodable>(model:M) -> [String:Any] {
        do {
            return try JSONSerialization.jsonObject(with:try JSONEncoder().encode(model)) as! [String:Any]
        } catch {
            return [:]
        }
    }
}
