//
//  WaitingRoomView.swift
//  SixTech
//
//  Created by 주환 on 2023/07/20.
//

import SwiftUI

struct WaitingRoomView: View {
    var body: some View {
        VStack {
            Text("대기실")
            Text("모두 도착할 때까지 기다려요.")
            Image("onboarding_character")
                .resizable()
                .scaledToFill()
                .frame(width: 136, height: 136)
                .background(
                    Circle().fill(Color.backgroundColor)
                        .frame(width: 170, height: 170)
                )
            Text("들린매스크")
                .padding()
            ScrollView {
                HStack {
                    Image("onboarding_character")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .scaledToFit()
                        .background(
                            Circle()
                                .fill(Color.backgroundColor)
                                .frame(width: 100, height: 100)
                        )
                    Text("팀원들은 참여코드를 입력하여 플로깅 팀에 참여해요.")
                        .font(.Jamsil.light.font(size: 16))

                }
                HStack {
                    Image("onboarding_character")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .scaledToFit()
                        .background(
                            Circle()
                                .fill(Color.backgroundColor)
                                .frame(width: 100, height: 100)
                        )
                    Text("팀원들은 참여코드를 입력하여\n플로깅 팀에 참여해요.")
                        .font(.Jamsil.light.font(size: 16))

                }
                HStack {
                    Image("onboarding_character")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .scaledToFit()
                        .background(
                            Circle()
                                .fill(Color.backgroundColor)
                                .frame(width: 100, height: 100)
                        )
                    Text("팀원들은 참여코드를 입력하여\n플로깅 팀에 참여해요.")
                        .font(.Jamsil.light.font(size: 16))

                }
                HStack {
                    Image("onboarding_character")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .scaledToFit()
                        .background(
                            Circle()
                                .fill(Color.backgroundColor)
                                .frame(width: 100, height: 100)
                        )
                    Text("팀원들은 참여코드를 입력하여\n플로깅 팀에 참여해요.")
                        .font(.Jamsil.light.font(size: 16))

                }
                HStack {
                    Image("onboarding_character")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .scaledToFit()
                        .background(
                            Circle()
                                .fill(Color.backgroundColor)
                                .frame(width: 100, height: 100)
                        )
                    Text("팀원들은 참여코드를 입력하여\n플로깅 팀에 참여해요.")
                        .font(.Jamsil.light.font(size: 16))

                }
                HStack {
                    Image("onboarding_character")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .scaledToFit()
                        .background(
                            Circle()
                                .fill(Color.backgroundColor)
                                .frame(width: 100, height: 100)
                        )
                    Text("팀원들은 참여코드를 입력하여\n플로깅 팀에 참여해요.")
                        .font(.Jamsil.light.font(size: 16))

                }
            }.background(
                RoundedRectangle(cornerRadius: 40).fill(Color.background2Color)
            )
        }.overlay {
            NavigationLink("시작하기") {
            }.buttonStyle(DefaultButton(isdisable: false))
                .offset(y: 350)
        }
    }
}

struct WaitingRoomView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoomView()
    }
}
