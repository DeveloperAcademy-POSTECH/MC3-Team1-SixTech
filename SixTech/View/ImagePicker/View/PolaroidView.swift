//
//  PolaroidView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/26.
//

import SwiftUI

struct PolaroidView: View {
    
    @State private var imagePickerPresented = false
    @Binding var selectedImage: UIImage?
    @Binding var isdisable: Bool
    @Binding var profileImage: Image?
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
        isdisable = false
        print("Image Pick Complete and isdisable false")
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0)
            
            VStack {
                Button {
                    print("Image Picking")
                    imagePickerPresented.toggle()
                } label: {
                    if isdisable {
                        Rectangle()
                            .foregroundColor(.beforeImagePickColor)
                            .overlay {
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.system(size: 40))
                                        .padding()
                                    Text("사진 추가하기...")
                                        .font(.system(size: 17))
                                    
                                }
                                .foregroundColor(.beforeImagePickTextColor)
                            }
                    } else {
                        // Image
                        Image(uiImage: selectedImage!)
                            .resizable()
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(.all, 12)
                .sheet(isPresented: $imagePickerPresented,
                       onDismiss: loadImage,
                       content: { ImagePicker(image: $selectedImage) })
                
                Text("\(UserDefaults.standard.string(forKey: "username") ?? "")")
                Text("Plz add Mission")
                Spacer()
            }
        }
        .padding(.horizontal, 45)
    }
}
