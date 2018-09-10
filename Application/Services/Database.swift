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
        guard
            let data = try? JSONSerialization.data(withJSONObject:json),
            let model = try? JSONDecoder().decode(M.self, from:data)
        else { return }
        completion(model)
    }
    
    private func json<M:Encodable>(model:M) -> [String:Any] {
        guard
            let data = try? JSONEncoder().encode(model),
            let json = try? JSONSerialization.jsonObject(with:data) as! [String:Any]
        else { return [:] }
        return json
    }
}
