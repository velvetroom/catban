import UIKit
import CleanArchitecture
import AVFoundation

class ScanView:View<ScanPresenter>, AVCaptureMetadataOutputObjectsDelegate {
    weak var camera:UIView!
    weak var message:UIView!
    weak var icon:UIImageView!
    weak var label:UILabel!
    private var session:AVCaptureSession?
    private var input:AVCaptureInput?
    private var output:AVCaptureMetadataOutput?
    private var previewLayer:AVCaptureVideoPreviewLayer?
    override var shouldAutorotate:Bool { get { return false } }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { get {
        return UIInterfaceOrientationMask.portrait } }
    
    func metadataOutput(_:AVCaptureMetadataOutput, didOutput objects:[AVMetadataObject], from:AVCaptureConnection) {
        guard
            let object:AVMetadataMachineReadableCodeObject = objects.first as? AVMetadataMachineReadableCodeObject,
            let string:String = object.stringValue
        else { return }
        self.cleanSession()
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.presenter.read(string:string)
    }
    
    override func viewDidLoad() {
        self.makeOutlets()
        self.layoutOutlets()
        self.configureViewModel()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = NSLocalizedString("ScanView.title", comment:String())
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        if self.session == nil {
            self.startSession()
        }
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        self.cleanSession()
    }
    
    private func makeOutlets() {
        let camera:UIView = UIView()
        camera.isUserInteractionEnabled = false
        camera.translatesAutoresizingMaskIntoConstraints = false
        camera.backgroundColor = UIColor.black
        self.camera = camera
        self.view.addSubview(camera)
        
        let message:UIView = UIView()
        message.isUserInteractionEnabled = false
        message.translatesAutoresizingMaskIntoConstraints = false
        self.message = message
        self.view.addSubview(message)
        
        let label:UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize:Constants.font, weight:UIFont.Weight.light)
        label.textColor = UIColor.black
        self.label = label
        self.message.addSubview(label)
        
        let icon:UIImageView = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.contentMode = UIView.ContentMode.center
        icon.isUserInteractionEnabled = false
        self.icon = icon
        self.message.addSubview(icon)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title:NSLocalizedString("ScanView.library", comment:String()), style:UIBarButtonItem.Style.plain,
                target:self.presenter, action:#selector(self.presenter.library))
    }
    
    private func layoutOutlets() {
        
        self.camera.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
        self.camera.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
        self.camera.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.camera.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        
        self.message.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
        self.message.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
        self.message.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        self.message.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        
        self.icon.widthAnchor.constraint(equalToConstant:Constants.image).isActive = true
        self.icon.heightAnchor.constraint(equalToConstant:Constants.image).isActive = true
        self.icon.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        self.icon.centerYAnchor.constraint(equalTo:self.view.centerYAnchor).isActive = true
        
        self.label.topAnchor.constraint(equalTo:self.icon.bottomAnchor).isActive = true
        self.label.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.never
        }
    }
    
    private func configureViewModel() {
        self.presenter.viewModels.observe { [weak self] (viewModel:ScanViewModel) in
            self?.icon.image = viewModel.icon
            self?.label.text = viewModel.text
            UIView.animate(withDuration:Constants.animation) { [weak self] in
                self?.camera.alpha = viewModel.alphaCamera
                self?.message.alpha = viewModel.alphaMessage
            }
        }
    }
    
    private func startSession() {
        let session:AVCaptureSession = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.hd1280x720
        let previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session:session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = self.camera.bounds
        self.previewLayer = previewLayer
        self.session = session
        self.startInput()
        self.startOutput()
        self.camera.layer.addSublayer(previewLayer)
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
    static let font:CGFloat = 16.0
    static let animation:TimeInterval = 0.3
    static let image:CGFloat = 80.0
}
