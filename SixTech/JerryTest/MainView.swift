//
//  MainView.swift
//  SixTech
//
//  Created by 주환 on 2023/07/20.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("오늘도 지구를 위해 함께 달려요!")
                    .font(.Jamsil.light.font(size: 17))
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color.backgroundColor)
                        .shadow(radius: 13)
                    VStack {
                        Image("onboarding_character")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                        Text("환경을 지키는 우리의 노력이 세상을 바꿉니다. \n오늘도 플로깅 화이팅하세요!")
                            .multilineTextAlignment(.center)
                            .font(.Jamsil.light.font(size: 16))
                            .padding()
                        
                        Button {
                            
                        } label: {
                            Text("같이줍깅 가이드 보러가기 ")
                                .font(.Jamsil.light.font(size: 14))
                            
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.init(hexCode: "#1A8370"))
                        .padding()

                    }
                }
                .frame(width: 342, height: 450)
                .padding()
                NavigationLink("방 만들기") {
                }.buttonStyle(DefaultButton(isdisable: false))
                NavigationLink("참여하기") {
                }.buttonStyle(DefaultButton(isdisable: false))
                    .padding()
                Spacer().frame(height: 60)
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    dismissButton {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("환영해요! 들린매스크 !")
                        .font(.Jamsil.bold.font(size: 20))
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
