import Foundation

public enum Exception:LocalizedError {
    case invalidId
    case noSession
    case invalidBoardUrl
    case boardAlreadyLoaded
    
    public var errorDescription:String? { return String(describing:self) }
}
