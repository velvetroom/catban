import Foundation
import Catban
import Firebase

class Database:DatabaseService {
    private let boards:CollectionReference
    
    required init() {
        self.boards = Firestore.firestore().collection(Constants.boards)
    }
    
    func load(identifier:String, board:@escaping((Board) -> Void), error:@escaping(() -> Void)) {
        self.boards.document(identifier).getDocument { [weak self] (snapshot:DocumentSnapshot?, _:Error?) in
            guard let json:[String:Any] = snapshot?.data() else { return error() }
            self?.loaded(json:json, completion:board)
        }
    }
    
    func create(board:Board) -> String {
        let document:DocumentReference = self.boards.addDocument(data:self.json(model:board))
        return document.documentID
    }
    
    func save(identifier:String, board:Board) {
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
