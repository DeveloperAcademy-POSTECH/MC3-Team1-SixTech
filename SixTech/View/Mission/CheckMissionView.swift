//
//  CheckMissionView.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/29.
//

import SwiftUI

struct CheckMissionView: View {
    @EnvironmentObject var userInfo: UserInfo
    @StateObject private var selectMission = SelectMission()

    var body: some View {
        VStack {
            Spacer()

            Text("나의 미션 확인하기")
                .font(.Jamsil.bold.font(size: 24))
                .padding(.bottom, 8)

            Text("플로깅 중 수행할 미션을 확인해요.")
                .font(.Jamsil.light.font(size: 20))
                .padding(.bottom)

            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .shadow(color: .black.opacity(0.25), radius: 20, y: 2)
                    .foregroundColor(.buttonBackgroundColor)

                VStack {

                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.background2Color)
                        .overlay(
                            // 유저 프로필 이미지
                            Image(uiImage: loadImageFromURL(imageURL: UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "")!))
                                .resizable()
                                .frame(width: 80, height: 80)
                        )
                        .padding(.bottom)

                    Text("같이줍깅 미션")
                        .font(.Jamsil.regular.font(size: 20))
                        .foregroundColor(.beforeImagePickTextColor)
                        .padding(.vertical)

                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white)

                        Text(selectMission.selectedMission)
                            .font(.Jamsil.regular.font(size: 20))
                    }
                    .frame(width: 294, height: 105)

                }
            }
            .frame(height: 360)
            .padding(.vertical)

            Spacer()

            HStack {
                Button {
                    selectMission.selectedMission = selectMission.getRandomMission()
                } label: {
                    VStack {
                        Image(systemName: "arrow.clockwise")
//                            .frame(width: 40, height: 40)
                            .font(.system(size: 36))
                            .fontWeight(.semibold)
                            .foregroundColor(.defaultColor)
                            .padding()
                            .background(Color.buttonBackgroundColor)
                            .clipShape(Circle())
                        .shadow(color: .black.opacity(0.25), radius: 10, y: 1)

                        Text("다시 고를래요!")
                            .font(.Jamsil.light.font(size: 17))
                            .padding(.bottom)
                            .foregroundColor(.black)
                    }
                }

                Spacer()
				
				VStack {
					VStack {
						NavigationLink {
							CountDownView()
								.navigationBarBackButtonHidden()
						} label: {
							Image(systemName: "checkmark")
//								.frame(width: 40, height: 40)
								.font(.system(size: 36))
								.fontWeight(.semibold)
								.foregroundColor(.buttonBackgroundColor)
								.padding()
								.background(Color.defaultColor)
								.clipShape(Circle())
								.shadow(color: .black.opacity(0.25), radius: 10, y: 1)
						}
                        .simultaneousGesture(TapGesture().onEnded({ _ in
                            userInfo.myMission = selectMission.selectedMission
                        }))
						Text("미션 확인")
							.font(.Jamsil.light.font(size: 17))
							.padding(.bottom)
							.foregroundColor(.black)
					}
				}
            }
            .padding(.horizontal, 40)
            .padding(.vertical)
        }
        .padding(.horizontal, 24)
    }
}

struct CheckMission_Previews: PreviewProvider {
    static var previews: some View {
        CheckMissionView()
    }
}
