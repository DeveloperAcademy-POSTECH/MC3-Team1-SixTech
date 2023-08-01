//
//  ImagePickView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/26.
//

import SwiftUI
import UIKit

struct ImagePickView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var matchManager: MatchManager
    
    @State private var isdisable: Bool = true
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @State private var imagePickerPresented = false
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
        matchManager.localPlayerInfo?.myMissionPhoto = selectedImage
        isdisable = false
        print("Image Pick Complete and isdisable false")
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("미션 사진 고르기")
                .font(.Jamsil.bold.font(size: 24))
                .padding()
            Text("제일 맘에 드는 사진을\n미션 결과로 골라요")
                .multilineTextAlignment(.center)
                .font(.Jamsil.light.font(size: 20))
                .padding(.bottom, 20)
            Button {
                print("Image Picking")
                imagePickerPresented.toggle()
            } label: {
                PolaroidView(isButtonPressed: .constant(false), isdisable: $isdisable, userName: userInfo.name, userMission: userInfo.myMission, image: profileImage, uiimage: userInfo.myMissionPhoto)
            }
            .sheet(isPresented: $imagePickerPresented,
                   onDismiss: loadImage,
                   content: { ImagePicker(image: $selectedImage, sourceType: .photoLibrary) })
            .padding(.horizontal, 45)
            
//            PolaroidView(isdisable: $isdisable, profileImage: $profileImage, userName: $userName, userMission: $userMission)

			NavigationLinkView(text: "골랐어요!", isdisable: $isdisable, destination: ShareImageView())
            .padding(.top, 100)
        }
        .onDisappear {
            matchManager.sendMissionImage()
            if matchManager.match?.players.count == matchManager.otherPlayerInfo?.count {
                matchManager.otherPlayerInfo?.insert(matchManager.localPlayerInfo!, at: 0)
            }
        }
    }
}

struct ImagePickView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickView()
            .environmentObject(MatchManager())
            .environmentObject(UserInfo())
    }
}
