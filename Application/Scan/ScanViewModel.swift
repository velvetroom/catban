import Foundation
import CleanArchitecture

struct ScanViewModel:ViewModel {
    var cameraHidden:Bool
    var successHidden:Bool
    var failHidden:Bool
    
    init() {
        self.cameraHidden = true
        self.successHidden = true
        self.failHidden = true
    }
}
