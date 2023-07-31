import SwiftUI
import AVFoundation

class Camera: NSObject, ObservableObject {
    var session = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let output = AVCapturePhotoOutput()
    var photoData = Data(count: 0)
    @AppStorage("profileURL") var profileImageURL: URL = UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "")!
    
    @Published var recentImage: UIImage?
    @Published var isCameraBusy = false

    // 카메라 셋업 과정을 담당하는 함수,
    func setUpCamera() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video, position: .back) {
            do { // 카메라가 사용 가능하면 세션에 input과 output을 연결
                videoDeviceInput = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(videoDeviceInput) {
                    session.addInput(videoDeviceInput)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                    output.isHighResolutionCaptureEnabled = true
                    output.maxPhotoQualityPrioritization = .quality
                }
                DispatchQueue.main.async {
                    self.session.startRunning()
                }
            } catch {
                print(error) // 에러 프린트
            }
        }
    }
    
    func requestAndCheckPermissions() {
        // 카메라 권한 상태 확인
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authStatus in
                if authStatus {
                    DispatchQueue.main.async {
                        self?.setUpCamera()
                    }
                }
            }
        case .restricted:
            break
        case .authorized:
            // 이미 권한 받은 경우 셋업
            setUpCamera()
        default:
            // 거절했을 경우
            print("Permession declined")
        }
    }
    
    func capturePhoto() {
        // 사진 옵션 세팅
        let photoSettings = AVCapturePhotoSettings()
        
        self.output.capturePhoto(with: photoSettings, delegate: self)
        print("[Camera]: Photo's taken")
    }
    
    func savePhoto(_ imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
//        let scaledImage = image.resize(to: size)
        let scaledImage = image.resizeAndCrop(to: size)
            
        let character = loadImageFromURL(imageURL: profileImageURL)
        let newImage = scaledImage!.overlayWith(image: character)
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        print("[Camera]: Photo's saved")
    }
    
    func zoom(_ zoom: CGFloat) {
        let factor = zoom < 1 ? 1 : zoom
        let device = self.videoDeviceInput.device
        
        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = factor
            device.unlockForConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func changeCamera() {
        let currentPosition = self.videoDeviceInput.device.position
        let preferredPosition: AVCaptureDevice.Position
        
        switch currentPosition {
        case .unspecified, .front:
            print("후면카메라로 전환합니다.")
            preferredPosition = .back
            
        case .back:
            print("전면카메라로 전환합니다.")
            preferredPosition = .front
            
        @unknown default:
            print("알 수 없는 포지션. 후면카메라로 전환합니다.")
            preferredPosition = .back
        }
        
        if let videoDevice = AVCaptureDevice
            .default(.builtInWideAngleCamera,
                     for: .video, position: preferredPosition) {
            do {
                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                self.session.beginConfiguration()
                
                if let inputs = session.inputs as? [AVCaptureDeviceInput] {
                    for input in inputs {
                        session.removeInput(input)
                    }
                }
                if self.session.canAddInput(videoDeviceInput) {
                    self.session.addInput(videoDeviceInput)
                    self.videoDeviceInput = videoDeviceInput
                } else {
                    self.session.addInput(self.videoDeviceInput)
                }
            
                if let connection =
                    self.output.connection(with: .video) {
                    if connection.isVideoStabilizationSupported {
                        connection.preferredVideoStabilizationMode = .auto
                    }
                }
                
                output.isHighResolutionCaptureEnabled = true
                output.maxPhotoQualityPrioritization = .quality
                
                self.session.commitConfiguration()
            } catch {
                print("Error occurred: \(error)")
            }
        }
    }
}

extension Camera: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        self.isCameraBusy = true
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        print("[CameraModel]: Capture routine's done")
        
        self.photoData = imageData
        self.recentImage = UIImage(data: imageData)
        self.savePhoto(imageData)
        self.isCameraBusy = false
    }
}

extension UIImage {
    func overlayWith(image: UIImage) -> UIImage {
        let newSize = CGSize(width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let characterSize = CGSize(width: 200, height: 200)
        let characterPoint = CGPoint(x: size.width/2 - characterSize.width/2, y: size.height/2 - characterSize.height/2)
        image.draw(in: CGRect(origin: characterPoint, size: characterSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }

    func resizeAndCrop(to size: CGSize) -> UIImage? {
          let scale = max(size.width / self.size.width, size.height / self.size.height)
          let newSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)

          let origin = CGPoint(x: (size.width - newSize.width) / 2.0, y: (size.height - newSize.height) / 2.0)
          let rect = CGRect(origin: origin, size: newSize)

          UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
          self.draw(in: rect)
          let newImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()

          return newImage
      }
}
