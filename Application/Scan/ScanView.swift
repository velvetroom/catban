import UIKit
import CleanArchitecture
import AVFoundation

class ScanView:View<ScanPresenter>, AVCaptureMetadataOutputObjectsDelegate {
    weak var bar:UIToolbar!
    weak var name:UILabel!
    private var session:AVCaptureSession?
    private var input:AVCaptureInput?
    private var output:AVCaptureMetadataOutput?
    private var previewLayer:AVCaptureVideoPreviewLayer?
    override var prefersStatusBarHidden:Bool { get { return true } }
    override var shouldAutorotate:Bool { get { return false } }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { get {
        return UIInterfaceOrientationMask.portrait } }
    
    override func viewDidLoad() {
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalPresentationCapturesStatusBarAppearance = true
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.startSession()
        self.makeOutlets()
        self.layoutOutlets()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        self.previewLayer?.frame = self.view.frame
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        self.cleanSession()
    }
    
    private func makeOutlets() {
        let bar:UIToolbar = UIToolbar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = UIColor.black
        bar.barTintColor = UIColor.black
        bar.tintColor = UIColor.white
        bar.isTranslucent = false
        bar.setBackgroundImage(UIImage(), forToolbarPosition:UIBarPosition.any, barMetrics:UIBarMetrics.default)
        bar.setShadowImage(UIImage(), forToolbarPosition:UIBarPosition.any)
        bar.setItems([UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.stop, target:self.presenter,
                                      action:#selector(self.presenter.cancel))], animated:false)
        self.bar = bar
        self.view.addSubview(bar)
        
        let name:UILabel = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isUserInteractionEnabled = false
        name.textAlignment = NSTextAlignment.center
        name.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.regular)
        name.textColor = UIColor.white
        name.text = NSLocalizedString("ScanView.name", comment:String())
        self.name = name
        self.view.addSubview(name)
    }
    
    private func layoutOutlets() {
        self.bar.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.bar.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        self.bar.heightAnchor.constraint(equalToConstant:Constants.bar).isActive = true
        if #available(iOS 11.0, *) {
            self.bar.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            self.bar.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
        }
        
        self.name.topAnchor.constraint(equalTo:self.bar.topAnchor).isActive = true
        self.name.bottomAnchor.constraint(equalTo:self.bar.bottomAnchor).isActive = true
        self.name.leftAnchor.constraint(equalTo:self.bar.leftAnchor).isActive = true
        self.name.rightAnchor.constraint(equalTo:self.bar.rightAnchor).isActive = true
    }
    
    private func startSession() {
        let session:AVCaptureSession = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.hd1280x720
        let previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session:session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer = previewLayer
        self.session = session
        self.startInput()
        self.startOutput()
        self.view.layer.addSublayer(previewLayer)
        session.startRunning()
    }
    
    private func cleanSession() {
        guard let session:AVCaptureSession = self.session else { return }
        session.stopRunning()
        if let input:AVCaptureInput = self.input { session.removeInput(input) }
        if let output:AVCaptureMetadataOutput = self.output { session.removeOutput(output) }
        self.session = nil
        self.input = nil
        self.output = nil
    }
    
    private func startInput() {
        let device:AVCaptureDevice
        if #available(iOS 10.0, *) {
            device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                             for:AVMediaType.video,
                                             position:AVCaptureDevice.Position.back)!
        } else {
            device = AVCaptureDevice.default(for:AVMediaType.video)!
        }
        do {
            let input:AVCaptureInput = try AVCaptureDeviceInput(device:device)
            self.session?.addInput(input)
            self.input = input
        } catch { return }
    }
    
    private func startOutput() {
        let output:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
        self.session?.addOutput(output)
        if output.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.qr) {
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        }
        output.setMetadataObjectsDelegate(self, queue:DispatchQueue.global(qos:DispatchQoS.QoSClass.background))
        self.output = output
    }
}

private struct Constants {
    static let bar:CGFloat = 44.0
    static let font:CGFloat = 14
}
