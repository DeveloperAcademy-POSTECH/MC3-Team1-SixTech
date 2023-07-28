//
//  ImagePickView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/26.
//

import SwiftUI

struct ImagePickView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    @State private var isdisable: Bool = true
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @State private var imagePickerPresented = false
    @State private var userMission: String?
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
        isdisable = false
        print("Image Pick Complete and isdisable false")
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("미션 사진 고르기")
                .font(.Jamsil.bold.font(size: 20))
                .padding()
            Text("제일 맘에 드는 사진을\n미션결과로 골라요")
                .multilineTextAlignment(.center)
                .font(.Jamsil.light.font(size: 17))
                .padding(.bottom, 30)
            Button {
                print("Image Picking")
                imagePickerPresented.toggle()
            } label: {
                PolaroidView(isdisable: $isdisable, profileImage: $profileImage, userMission: $userMission)
            }
            .sheet(isPresented: $imagePickerPresented,
                   onDismiss: loadImage,
                   content: { ImagePicker(image: $selectedImage) })
            .padding(.horizontal, 45)
            //                PolaroidView(isdisable: $isdisable, profileImage: $profileImage, userName: $userName, userMission: $userMission)
            NavigationLinkView(text: "골랐어요!", isdisable: $isdisable, destination: EndResultView())
                .padding(.top, 100)
        }
        .navigationBarBackButtonHidden()
        
    }
}

struct ImagePickView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickView()
            .environmentObject(UserInfo())
    }
}
