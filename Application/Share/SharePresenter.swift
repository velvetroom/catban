import CleanArchitecture
import Catban
import QRhero

class SharePresenter:Presenter {
    weak var board:Board!
    var boardUrl = String()
    private let hero = Hero()
    @objc func done() { Application.navigation.dismiss(animated:true) }
    
    func send(image:UIImage) {
        guard let url = prepare(image:image) else { return }
        let view = UIActivityViewController(activityItems:[url], applicationActivities:nil)
        if let popover = view.popoverPresentationController {
            popover.sourceView = Application.navigation.view
            popover.sourceRect = .zero
            popover.permittedArrowDirections = .any
        }
        Application.navigation.dismiss(animated:true) {
            Application.navigation.present(view, animated:true)
        }
    }
    
    override func didLoad() {
        hero.write(content:boardUrl) { [weak self] image in
            self?.update(viewModel:image)
        }
    }
    
    private func prepare(image:UIImage) -> URL? {
        guard
            let cg = image.cgImage,
            let image = decorate(code:cg)
        else { return nil }
        return temporalUrl(image:image)
    }
    
    private func decorate(code:CGImage) -> UIImage? {
        let size = CGSize(width:CGFloat(code.width) + 90, height:CGFloat(code.height) + 170)
        UIGraphicsBeginImageContext(size)
        NSAttributedString(string:board.name, attributes:[
            .font:UIFont.systemFont(ofSize:40, weight:.bold), .foregroundColor:UIColor.black]).draw(in:
                CGRect(x:115, y:size.height - 94, width:CGFloat(code.width), height:50))
        UIGraphicsGetCurrentContext()!.translateBy(x:0, y:size.height)
        UIGraphicsGetCurrentContext()!.scaleBy(x:1, y:-1)
        UIGraphicsGetCurrentContext()!.draw(#imageLiteral(resourceName: "assetLogo.pdf").cgImage!, in:CGRect(x:51, y:45, width:50, height:50))
        UIGraphicsGetCurrentContext()!.draw(code, in:CGRect(x:45, y:125, width:CGFloat(code.width), height:CGFloat(code.height)))
        let image = UIImage(cgImage:UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
        return image
    }
    
    func temporalUrl(image:UIImage) -> URL? {
        let url = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("Catban.jpeg")
        try? image.jpegData(compressionQuality:1)!.write(to:url, options:.atomicWrite)
        return url
    }
}
