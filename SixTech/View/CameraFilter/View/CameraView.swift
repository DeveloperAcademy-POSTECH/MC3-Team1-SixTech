import SwiftUI
import AVFoundation
import Photos

// 아무리 삽질해도 제가 생각하던 방식으로 구현이 안되더라구요.. 돌고 돌아 원래 코드 그대로 돌아왔습니다..

struct CameraView: View {
        @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        ZStack {
            
            Group {
                viewModel.cameraPreview
                    .frame(height: UIScreen.main.bounds.width)
                        .onAppear {
                            viewModel.configure()
                        }
                Image(uiImage: loadImageFromURL(imageURL: UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "")!))
                    .resizable()
                    .frame(width: 200, height: 200)
                
            }.gesture(MagnificationGesture()
                .onChanged { value in
                    viewModel.zoom(factor: value)
                }
                .onEnded { _ in
                    viewModel.zoomInitialize()
                }
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                ZStack {
                    Button {
                        viewModel.capturePhoto()
//                        screenShot()
                    } label: {
                        ShutterButton()
                    }
                    HStack {
                        Spacer()
                        Button {
                            viewModel.changeCamera()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            
                        }
                        .frame(width: 75, height: 75)
                        .foregroundColor(.white)
                        .padding()
                    }
                    
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct CameraPreviewView: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    let session: AVCaptureSession

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()

        view.videoPreviewLayer.session = session
        view.backgroundColor = .black
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.connection?.videoOrientation = .portrait

        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {

    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(viewModel: CameraViewModel())
    }
}

struct ShutterButton: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 65, height: 65)
            Circle()
                .stroke(Color .white, lineWidth: 2)
                .frame(width: 75, height: 75)
        }
    }
}

extension CameraView {
    func screenShot() {
        let screenshot = body.takeScreenshot(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size)
            .resizeAndCrop(to: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))!
        
        UIImageWriteToSavedPhotosAlbum(screenshot, self, nil, nil)
    }
}

//struct CameraPreviewView: UIViewControllerRepresentable {
//    let session: AVCaptureSession
//        class VideoPreviewView: UIView {
//            override class var layerClass: AnyClass {
//                AVCaptureVideoPreviewLayer.self
//            }
//
//            var videoPreviewLayer: AVCaptureVideoPreviewLayer {
//                return layer as! AVCaptureVideoPreviewLayer
//            }
//        }
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = UIViewController()
//        let videoPreviewView = VideoPreviewView()
//
//        videoPreviewView.videoPreviewLayer.session = session
//        videoPreviewView.backgroundColor = .black
//        videoPreviewView.videoPreviewLayer.videoGravity = .resizeAspectFill
//        videoPreviewView.videoPreviewLayer.cornerRadius = 0
//        videoPreviewView.videoPreviewLayer.connection?.videoOrientation = .portrait
//
//        viewController.view.addSubview(videoPreviewView)
//        videoPreviewView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            videoPreviewView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
//            videoPreviewView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
//            videoPreviewView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
//            videoPreviewView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
//        ])
//
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}
