import UIKit
import CoreImage

class Qr {
    func generate(message:String, completion:@escaping((UIImage) -> Void)) {
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async { [weak self] in
            guard let image:UIImage = self?.generate(message:message) else { return }
            DispatchQueue.main.async { completion(image) }
        }
    }
    
    private func generate(message:String) -> UIImage? {
        guard
            let filter:CIFilter = CIFilter(name:Constants.filter),
            let data:Data = message.data(using:String.Encoding.utf8, allowLossyConversion:false)
            else { return nil }
        filter.setValue(Constants.value, forKey:Constants.key)
        filter.setValue(data, forKey:Constants.content)
        let transform = CGAffineTransform(scaleX:Constants.scale, y:Constants.scale)
        guard
            let ci:CIImage = filter.outputImage?.transformed(by:transform),
            let cg:CGImage = CIContext().createCGImage(ci, from:ci.extent)
        else { return nil }
        return UIImage(cgImage:cg, scale:Constants.saveScale, orientation:UIImage.Orientation.up)
    }
}

private struct Constants {
    static let filter:String = "CIQRCodeGenerator"
    static let key:String = "inputCorrectionLevel"
    static let value:String = "H"
    static let content:String = "inputMessage"
    static let scale:CGFloat = 10.0
    static let saveScale:CGFloat = 1.0
}
