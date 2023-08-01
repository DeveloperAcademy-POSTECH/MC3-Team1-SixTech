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
                    Text("\(1 + (matchManager.otherPlayerInfo?.count ?? 1))/\(matchManager.maxPlayer)")
                        .font(.Jamsil.light.font(size: 20))
                        .foregroundColor(.fontColor)
                        .padding(.top)
                    
                    PlayerCellView(image: userInfo.profileImageURL, nickName: userInfo.name)
                    if matchManager.otherPlayerInfo != nil {
                        ForEach(matchManager.otherPlayerInfo!) { info in
                            PlayerCellView(image: info.profileImageURL, nickName: info.name, uiimage: info.profileImage)
                        }
                    }
                }.background(
                    RoundedRectangle(cornerRadius: 40).fill(Color.background2Color)
                )
                .clipShape(RoundedRectangle(cornerRadius: 40))
                
            }
            .padding(.top)
            .overlay {
                VStack {
                    Text("􀁜 모든 멤버가 입장하면 시작할 수 있어요.")
                        .font(.Jamsil.light.font(size: 14))
                        .foregroundColor(.gray)
                        .offset(y: 300)
                    NavigationLink("시작하기") {
						CheckMissionView()
							.navigationBarBackButtonHidden()
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
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("대기실")
                            .font(.Jamsil.bold.font(size: 24))
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
        
        .onAppear {
            if let playCode = groupCode, isFirst {
                matchManager.groupNumber = playCode
                matchManager.startMatchmaking()
                isFirst = false
            } else if isFirst {
                matchManager.startMatchmaking()
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
    var image: URL
    let nickName: String
    var uiimage: [Int]?
    let viewModel = CharacterCreateViewModel()
    
    var body: some View {
        HStack {
            if let index = uiimage {
                Image(uiImage: viewModel.imageMerger.merge("\(viewModel.faceArray[index[0]] + viewModel.colorArray[index[1]])", with: "\(viewModel.emotionArray[index[2]])"))
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
            .onAppear {
                if let uiimage = uiimage {
                    print("\(uiimage)")
                }
            }
    }
}
