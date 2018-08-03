import Foundation

class Localized {
    class func string(key:String) -> String {
        return NSLocalizedString(key, tableName:"Domain", bundle:Bundle(for:Localized.self), comment:String())
    }
    
    private init() { }
}
