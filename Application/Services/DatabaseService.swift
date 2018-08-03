import Foundation
import Domain
import Firebase

class DatabaseService:DatabaseServiceProtocol {
    required init() { }
    
    func loadRemote() {
        //        Firestore.firestore().document(identifier).getDocument { [weak self] (snap:DocumentSnapshot?, fail:Error?) in
        //            if let fail:Error = fail {
        //                error(fail)
        //            } else if let json:[String:Any] = snap?.data() {
        //                self?.loaded(json:json, completion:board, error:error)
        //            } else {
        //                error(RepositoryError.boardNotFound)
        //            }
        //        }
    }
    
    func load<M>(identifier:String, board:@escaping((M) -> Void)) where M:Codable & BoardProtocol {
        
    }
    
    func create<M>(board:M, completion:@escaping((String) -> Void)) where M:Codable & BoardProtocol {
//        Firestore.firestore().runTransaction( { (transaction:Transaction, errorPointer:NSErrorPointer) -> Any? in
//            
//        }, completion: { (any:Any?, error:Error?) in
//            
//        })
        
        
        let document:DocumentReference = Firestore.firestore().collection(Constants.boards).addDocument(
            data:self.json(model:board))
        completion(document.documentID)
    }
    
    private func loaded<Model:Decodable>(json:[String:Any], completion:@escaping((Model) -> Void),
                                         error:@escaping((Error) -> Void)) {
        do {
            let data:Data = try JSONSerialization.data(withJSONObject:json, options:JSONSerialization.WritingOptions())
            let model:Model = try JSONDecoder().decode(Model.self, from:data)
            completion(model)
        } catch let throwingError {
            error(throwingError)
        }
    }
    
    private func json<Model:Encodable>(model:Model) -> [String:Any] {
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
