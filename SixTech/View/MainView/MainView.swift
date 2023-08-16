//
//  MainView.swift
//  SixTech
//
//  Created by 주환 on 2023/07/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var userInfo: UserInfo
    
    @State private var isFirst = true
    
    var body: some View {
        VStack {
            Text("환영해요! \(userInfo.name)!")
                .font(.Jamsil.bold.font(size: 24))
                .padding(.top, 50)
            
            Text("오늘도 지구를 위해 함께 걸어요!")
                .font(.Jamsil.light.font(size: 17))
                .padding()
            Spacer()
            Image(uiImage: loadImageFromURL(imageURL: userInfo.profileImageURL))
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFill()
                .padding()
            Spacer()
            Spacer()
//            NavigationLink("플로깅 플레이") {
//                PloggingPlayView()
//            }.buttonStyle(DefaultButton(isdisable: false))
            NavigationLinkView(text: "플로깅 플레이", isdisable: .constant(false), destination: PloggingPlayView())
                .padding(.top)
//            NavigationLink("내 프로필") {
//                MyprofileView()
//            }.buttonStyle(ProfileButton(isdisable: false))
//                .padding(.bottom)
            NavigationLinkView(text: "내 프로필", isdisable: .constant(false), destination: MyprofileView())
            Spacer()
        }
        .background {
            Image("MainBack")
                .offset(y: -7)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if isFirst {
                matchManager.authenticateUser()
                matchManager.localPlayerInfo = userInfo
                
                isFirst = false
            }
            userInfo.updateUserInfo()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MatchManager())
            .environmentObject(UserInfo())
    }
}
