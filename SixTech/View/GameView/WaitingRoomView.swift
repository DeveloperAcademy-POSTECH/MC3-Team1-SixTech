//
//  WaitingRoomView.swift
//  SixTech
//
//  Created by 주환 on 2023/07/20.
//

import SwiftUI
import UIKit

struct WaitingRoomView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var matchManager: MatchManager
    @Environment(\.dismiss) var dismiss
    
    @State var isAlert = false
    @State var isFirst = true
    var groupCode: String?
    
    var body: some View {
        ZStack {
            VStack {
                Text("대기실")
                    .font(.Jamsil.bold.font(size: 24))
                
                Text("모두 도착할 때까지 기다려요.")
                    .font(.Jamsil.light.font(size: 20))
                
                Image(uiImage: loadImageFromURL(imageURL: userInfo.profileImageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 136, height: 136)
                    .background(
                        Circle().fill(Color.background2Color)
                            .frame(width: 170, height: 170)
                    )
                    .padding()
                
                Text(userInfo.name)
                    .font(.Jamsil.bold.font(size: 25))
                    .padding()
                
                ScrollView {
                    PlayerCellView(image: userInfo.profileImageURL, nickName: userInfo.name)
                    if matchManager.otherPlayerInfo != nil {
                        ForEach(matchManager.otherPlayerInfo!) { info in
                            PlayerCellView(image: info.profileImageURL, nickName: info.name, uiimage: info.profileImage)
                        }
//                        ForEach(matchManager.otherPlayerInfo!, id: \.self) { info in
//                            PlayerCellView(image: info.profileImageURL, nickName: matchManager.lastData)
//                        }
                    }
                }.background(
                    RoundedRectangle(cornerRadius: 40).fill(Color.background2Color)
                )
                .clipShape(RoundedRectangle(cornerRadius: 40))
                
            }
            .overlay {
                VStack {
                    Text("􀁜 모든 멤버가 입장하면 시작할 수 있어요.")
                        .font(.Jamsil.light.font(size: 14))
                        .foregroundColor(.gray)
                        .offset(y: 300)
                    NavigationLink("시작하기") {
                        MapView()
                    }.buttonStyle(DefaultButton(isdisable: false))
                        .offset(y: 300)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    dismissButton(sfName: "xmark") {
                        isAlert = true
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
        
        .onAppear {
            if let playCode = groupCode, isFirst {
                matchManager.groupNumber = playCode
                matchManager.startMatchmaking(nil)
                isFirst = false
            } else if isFirst {
                matchManager.startMatchmaking(nil)
                isFirst = false
            }
        }
        .alert(title: "대기실 나가기", message: "메인 화면으로 돌아갑니다.",
               primaryButton: CustomAlertButton(title: "나가기", action: {
            matchManager.cancelMatchmaking()
            dismiss() }),
               secondaryButton: CustomAlertButton(title: "취소", action: { isAlert = false }),
               isPresented: $isAlert)
    }
}

struct PlayerCellView: View {
    let image: URL
    let nickName: String
    var uiimage: UIImage?
    
    var body: some View {
        HStack {
            if let uiimage = uiimage {
                Image(uiImage: uiimage)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .scaledToFill()
                    .background(
                        Circle()
                            .fill(Color.backgroundColor)
                            .frame(width: 100, height: 100)
                    )
                    .padding(.all, 20)
            } else {
                Image(uiImage: loadImageFromURL(imageURL: image))
                    .resizable()
                    .frame(width: 80, height: 80)
                    .scaledToFill()
                    .background(
                        Circle()
                            .fill(Color.backgroundColor)
                            .frame(width: 100, height: 100)
                    )
                    .padding(.all, 20)
            }
            Text(nickName)
                .font(.Jamsil.regular.font(size: 25))
            Spacer()
            
        }.frame(width: 342)
    }
}
