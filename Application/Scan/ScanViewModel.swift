import UIKit
import CleanArchitecture

struct ScanViewModel:ViewModel {
    var alphaCamera:CGFloat
    var alphaMessage:CGFloat
    var icon:UIImage?
    var text:String
    
    init() {
        self.alphaCamera = 0.0
        self.alphaMessage = 0.0
        self.text = String()
    }
}
