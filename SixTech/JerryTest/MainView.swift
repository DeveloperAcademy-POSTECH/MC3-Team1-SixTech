//
//  MainView.swift
//  SixTech
//
//  Created by 주환 on 2023/07/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Text("환영해요 ! 들린매스크 !")
                .font(.Jamsil.bold.font(size: 20))
            
            Text("오늘도 지구를 위해 함께 달려요!")
                .font(.Jamsil.light.font(size: 17))
                .padding()
            
            Image("onboarding_character")
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFill()
                .padding()
            
            
            NavigationLink("플로깅 플레이") {
            }.buttonStyle(DefaultButton(isdisable: false))
                .padding()
            NavigationLink("내 프로필") {
            }.buttonStyle(DefaultButton(isdisable: false))

        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
