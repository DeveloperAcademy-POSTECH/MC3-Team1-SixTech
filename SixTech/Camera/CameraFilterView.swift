//
//  ContentView.swift
//  earth2
//
//  Created by 신정연 on 2023/07/27.
//
import SwiftUI
import RealityKit
import PhotosUI

struct CameraFilterView: View {
    @State private var isAlbumPresented = false
    @State private var isboltClicked = false
    @State private var capturedImage: UIImage?
    @State private var useFrontCamera = false
    @State private var currentIndex: Int = 0
    @State private var dummyImage: UIImage?
    
    @StateObject private var cameraModel = CameraModel()
    @AppStorage("profileURL") var profileImageURL: URL = UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "")!
    
    var body: some View {
        let filterIndex = currentIndex % 3
        ZStack {
            if filterIndex == 0 {
                ZStack {
                    ARViewContainer(useFrontCamera: $useFrontCamera, cameraModel: cameraModel, currentIndex: $currentIndex)
                    Image(uiImage: loadImageFromURL(imageURL: profileImageURL))
                        .resizable()
                        .frame(width: 200, height: 200)
                }
            } else if filterIndex == 1 {
                ARViewContainer(useFrontCamera: $useFrontCamera, cameraModel: cameraModel, currentIndex: $currentIndex)
            } else if filterIndex == 2 {
                ARViewContainer(useFrontCamera: $useFrontCamera, cameraModel: cameraModel, currentIndex: $currentIndex)
            }
            VStack {
                VStack {
                    HStack {
                        Button {
                            // map으로 연결
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .font(.system(size: 25))
                                .frame(width: 25, height: 25)
                                .padding(30)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing)
                        Spacer()
                        Button {
                            isboltClicked.toggle()
                            cameraModel.toggleFlash()
                        } label: {
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
                // camera
                VStack {
                    FilterCarouselView(capturedImage: $dummyImage, currentIndex: $currentIndex, spacing: 10, trailingSpace: 20, itemWidth: 100)

                        .padding(.bottom, 1)
                    HStack {
                        Button {
                            isAlbumPresented = true
                        } label: {
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .font(.system(size: 24))
                                .frame(width: 30, height: 24)
                                .padding(20)
                                .foregroundColor(.white)
                            
                        }
                        .padding(.trailing)
                        Spacer()
                        Button {
                            useFrontCamera.toggle()
                        } label: {
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
    private func saveImageToAlbum() {
        print("save image to album")
        guard let image = capturedImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

struct CameraFilterView_Previews: PreviewProvider {
    static var previews: some View {
        CameraFilterView()
    }
}
