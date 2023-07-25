import SwiftUI
import AVFoundation

// 너무 야매여서 일단 넘어가고 .snapshot 모디파이어가 있는데, 일단 카메라는 이대로 두고 다른 거 하다가 시간 괜찮으면 다시 작업하겠습니다 ㅠㅠㅠㅠㅠㅠㅠ

struct CameraView: View {
    @ObservedObject var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            
            Group {
                viewModel.cameraPreview.ignoresSafeArea()
                    .frame(height: UIScreen.main.bounds.width)
                    .onAppear {
                        viewModel.configure()
                    }
                
                Image("face_dust_gray")
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
            
            VStack {
                Spacer()
                ZStack {
                    Button {
                        viewModel.capturePhoto()
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
        CameraView()
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
