import Foundation
import Domain
import Firebase

class DatabaseService:DatabaseServiceProtocol {
    private let boards:CollectionReference
    
    required init() {
        self.boards = Firestore.firestore().collection(Constants.boards)
    }
    
    func load<M>(identifier:String, board:@escaping((M) -> Void)) where M:Codable & BoardProtocol {
        self.boards.document(identifier).getDocument { [weak self] (snapshot:DocumentSnapshot?, _:Error?) in
            guard let json:[String:Any] = snapshot?.data() else { return }
            self?.loaded(json:json, completion:board)
        }
    }
    
    func create<M>(board:M) -> String where M:Codable & BoardProtocol {
        let document:DocumentReference = self.boards.addDocument(data:self.json(model:board))
        return document.documentID
    }
    
    func save<M>(identifier:String, board:M) where M:Codable & BoardProtocol {
        self.boards.document(identifier).setData(self.json(model:board))
    }
    
    private func loaded<M:Codable>(json:[String:Any], completion:@escaping((M) -> Void)) {
        do {
            let data:Data = try JSONSerialization.data(withJSONObject:json, options:JSONSerialization.WritingOptions())
            let model:M = try JSONDecoder().decode(M.self, from:data)
            completion(model)
        } catch { }
    }
    
    private func json<M:Encodable>(model:M) -> [String:Any] {
        do {
            let data:Data = try JSONEncoder().encode(model)
            let json:Any = try JSONSerialization.jsonObject(with:data, options:JSONSerialization.ReadingOptions())
            return json as! [String:Any]
        } catch {
            return [:]
        }
    }
}

private struct Constants {
    static let boards:String = "Boards"
}
