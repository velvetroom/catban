import Foundation

struct DomainError:LocalizedError {
    let errorDescription:String?
    
    static let noSession:DomainError = DomainError(errorDescription:error(key:"DomainError.noSession"))
    static let sessionLoaded:DomainError = DomainError(errorDescription:error(key:"DomainError.sessionLoaded"))
    static let noBoardSelected:DomainError = DomainError(errorDescription:error(key:"DomainError.noBoardSelected"))
    
    private static func error(key:String) -> String {
        return NSLocalizedString(key, tableName:"Domain", bundle:Bundle(for:Library.self), comment:String())
    }
}
