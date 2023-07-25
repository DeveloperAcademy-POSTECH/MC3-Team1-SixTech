import SwiftUI
import AVFoundation
import Combine

class CameraViewModel: ObservableObject {
    let model: Camera
    private let session: AVCaptureSession
    private var subscriptions = Set<AnyCancellable>()
    private var isCameraBusy = false
    let profileImageURL: URL
    let cameraPreview: AnyView
    let hapticImpact = UIImpactFeedbackGenerator()
    
    var currentZoomFactor: CGFloat = 1.0
    var lastScale: CGFloat = 1.0

    @Published var showPreview = false
    @Published var shutterEffect = false
    @Published var recentImage: UIImage?
    
    // 초기 세팅
    func configure() {
        model.requestAndCheckPermissions()
    }
    
    // 사진 촬영
    func capturePhoto() {
        
        if isCameraBusy == false {
            hapticImpact.impactOccurred()
            withAnimation(.easeInOut(duration: 0.1)) {
                shutterEffect = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.shutterEffect = false
                }
            }
            
            model.capturePhoto()
            print("[CameraViewModel]: Photo captured!")
        } else {
            print("[CameraViewModel]: Camera's busy.")
        }
    }
    
    func zoom(factor: CGFloat) {
        let delta = factor / lastScale
        lastScale = factor
        
        let newScale = min(max(currentZoomFactor * delta, 1), 5)
        model.zoom(newScale)
        currentZoomFactor = newScale
    }
    
    func zoomInitialize() {
        lastScale = 1.0
    }
    
    // 전후면 카메라 스위칭
    func changeCamera() {
        model.changeCamera()
        print("[CameraViewModel]: Camera changed!")
    }
    
    init(profileImageURL: URL) {
            self.profileImageURL = profileImageURL
            model = Camera(profileImageURL: profileImageURL)
            session = model.session
            cameraPreview = AnyView(CameraPreviewView(session: session))

            model.$recentImage.sink { [weak self] (photo) in
                guard let picture = photo else { return }
                self?.recentImage = picture
            }
            .store(in: &self.subscriptions)

            model.$isCameraBusy.sink { [weak self] (result) in
                self?.isCameraBusy = result
            }
            .store(in: &self.subscriptions)
        }
}
