//
//  ContentView.swift
//  earth2
//
//  Created by 신정연 on 2023/07/27.
//
import SwiftUI
import RealityKit
import PhotosUI

struct CameraFilterView : View {
    @State private var isCameraPresented = false
    @State private var isAlbumPresented = false
    @State private var isboltClicked = false
    @State private var capturedImage: UIImage? = nil
    
    @StateObject private var cameraModel = CameraModel()
    
    var body: some View {
        ZStack {
            ARViewContainer().edgesIgnoringSafeArea(.all)
            VStack {
                VStack{
                    HStack{
                        Button(action: {
                            
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .font(.system(size: 25))
                                .frame(width: 25, height: 25)
                                .padding(30)
                                .foregroundColor(.white)
                            
                        }
                        .padding(.trailing)
                        Spacer()
                        Button(action: {
                            cameraModel.toggleFlash()
                        }) {
                            Image(systemName: isboltClicked ? "bolt.slash.fill" : "bolt.fill")
                                .resizable()
                                .font(.system(size: 25))
                                .frame(width: 25, height: 30)
                                .padding(30)
                                .foregroundColor(.white)
                            
                        }
                        .padding(.leading)
                    }
                }
                .background(Color.black)
                Spacer()
                    .frame(height: 400)
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            let rect = CGRect(origin: .zero, size: CGSize(width: geometry.size.width, height: 400))
                            capturedImage = UIApplication.shared.windows.first?.rootViewController?.view.asImage(in: rect)
                        }
                    })
                //camera
                VStack{
                    FilterCarouselView(capturedImage: $capturedImage)
                        .padding(.bottom, 1)
                    HStack {
                        Button(action: {
                            isAlbumPresented = true
                        }) {
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .font(.system(size: 24))
                                .frame(width: 30, height: 24)
                                .padding(20)
                                .foregroundColor(.white)
                            
                        }
                        .padding(.trailing)
                        Spacer()
                        Button(action: {
                            cameraModel.toggleCamera()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .resizable()
                                .frame(width: 30, height: 24)
                                .font(.system(size: 24))
                                .padding(20)
                                .foregroundColor(.white)
                        }
                        .padding(.leading)
                    }
                    .padding(.bottom)
                }
                .background(Color.black)
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isAlbumPresented, onDismiss: saveImageToAlbum) {
            ImagePicker(image: $capturedImage, sourceType: .photoLibrary)
        }
    }
    // 사진을 앨범에 저장하는 함수
    private func saveImageToAlbum() {
        print("save image to album")
        guard let image = capturedImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

struct CameraFilterView_Previews : PreviewProvider {
    static var previews: some View {
        CameraFilterView()
    }
}
