import Foundation

struct DomainError:LocalizedError {
    let errorDescription:String?
    
    static let noSession:DomainError = DomainError(errorDescription:string(key:"DomainError.noSession"))
    static let sessionLoaded:DomainError = DomainError(errorDescription:string(key:"DomainError.sessionLoaded"))
    static let noBoardSelected:DomainError = DomainError(errorDescription:string(key:"DomainError.noBoardSelected"))
    
    private static func string(key:String) -> String {
        return NSLocalizedString(key, tableName:"Domain", bundle:Bundle(for:Library.self), comment:String())
    }
}
