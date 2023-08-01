//
//  Myprofile.swift
//  SixTech
//
//  Created by 주환 on 2023/07/26.
//

import SwiftUI

struct MyprofileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userInfo: UserInfo
    
    @State var nickName: String = "" // 추후 텍스트필드 적용할 것.
    
    var body: some View {
        
        VStack(spacing: 18) {
            textBackgroundView(st1: "닉네임", st2: userInfo.name)
            textBackgroundView(st1: "프로필 변경", nextView: CharacterChangeView())
            textBackgroundView(st1: "이전기록", nextView: MyHistoryView())
            Spacer()
            textBackgroundView(st1: "이용 약관 및 개인정보 처리방침", nextView: Text("준비중"))
            textBackgroundView(st1: "개발자 정보", nextView: DeveloperInfoView())
            Spacer()
            
        }.padding()
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    dismissButton(sfName: "chevron.backward") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("내 프로필")
                        .font(.Jamsil.bold.font(size: 20))
                }
                
            }
            .navigationBarBackButtonHidden()
        
    }
    
    func textBackgroundView(st1: String, st2: String) -> some View {
        HStack {
            Text(st1)
                .font(.Jamsil.medium.font(size: 18))
                .padding()
            Spacer()
            Text(st2)
                .font(.Jamsil.light.font(size: 18))
                .padding()
            Spacer()
        }.background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color(red: 0.96, green: 0.96, blue: 0.96))
        )
    }
    func textBackgroundView(st1: String, nextView: some View) -> some View {
        NavigationLink(destination: nextView) {
            HStack {
                Text(st1)
                    .lineLimit(1)
                    .font(.Jamsil.medium.font(size: 18))
                    .foregroundColor(.black)
                    .padding()
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.defaultColor)
                    .fontWeight(.bold)
                    .padding()
            }
        }.background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color(red: 0.96, green: 0.96, blue: 0.96))
        )
    }
}

struct MyprofileView_Previews: PreviewProvider {
    static var previews: some View {
        MyprofileView()
            .environmentObject(UserInfo())
    }
}
