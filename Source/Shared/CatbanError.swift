import Foundation

public enum CatbanError:LocalizedError {
    case noSession
    case invalidBoardUrl
    case boardAlreadyLoaded
    
    public var errorDescription:String? { return String(describing:self) }
}
