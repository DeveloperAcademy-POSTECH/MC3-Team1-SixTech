//
//  ShareImge.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/27.
//

import SwiftUI
import UIKit
import Photos

struct ShareImageView: View {
    @EnvironmentObject var matchManager: MatchManager
    
    @State var currentIndex: Int = 0
    @State var isButtonPressed: Bool = false
    @State private var isNextView = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ImageButton(image: .right) {
                    isNextView = true
                }
                .padding(.trailing)
            }
            
            Text("플로깅이 끝났어요.")
                .font(.Jamsil.bold.font(size: 24))
				.padding(.bottom)
            Text("미션 결과를 팀원들과 공유해요.")
                .font(.Jamsil.light.font(size: 20))
            
            Text("\(currentIndex+1) / \(1 + matchManager.otherPlayerInfo!.count)")
                .font(.Jamsil.light.font(size: 17))
                .padding()
            
            SnapCarousel(index: $currentIndex, items: matchManager.otherPlayerInfo!) { info in
                PolaroidView(isButtonPressed: $isButtonPressed, isdisable: .constant(false), userName: info.name, userMission: info.myMission, image: nil, uiimage: info.myMissionPhoto, profileImage: info.profileImage)
            }
            
            Spacer()
            
            Button {
                // 저장하는 기능
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                        .padding(.trailing)
                    
                    Text("저장하기")
                        .padding(.trailing)
                }
            }
            .buttonStyle(SmallButton())
            .padding(.top, 100)
            
            NavigationLink("", isActive: $isNextView) {
                EndResultView()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ShareImageView()
            .environmentObject(MatchManager())
    }
}
