import Foundation

struct DomainError:LocalizedError {
    let errorDescription:String?
    
    static let noSession:DomainError = DomainError(errorDescription:
        Localized.string(key:"DomainError.noSession"))
    static let sessionLoaded:DomainError = DomainError(errorDescription:
        Localized.string(key:"DomainError.sessionLoaded"))
    static let noBoardSelected:DomainError = DomainError(errorDescription:
        Localized.string(key:"DomainError.noBoardSelected"))
}
