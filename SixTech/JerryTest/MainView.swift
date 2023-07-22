//
//  MainView.swift
//  SixTech
//
//  Created by 주환 on 2023/07/20.
//

import SwiftUI

struct MainView: View {
    
    @State var isFlipped = true
    @State var backDegree = 90.0
    @State var frontDegree = 0.0
    let durationAndDelay: CGFloat = 0.3
    
    var body: some View {
        NavigationView {
            VStack {
                Text("환영해요! 들린매스크 !")
                    .font(.Jamsil.bold.font(size: 20))
                    .padding(.top, 86)
                Text("오늘도 지구를 위해 함께 달려요!")
                    .font(.Jamsil.light.font(size: 17))
                    .padding(.top, 14)
                
                ZStack {
                    FrontView(degree: $frontDegree)
                        .padding(.top)
                    BackView(degree: $backDegree)
                        .padding(.top)
                }.onTapGesture {
                    flipCard()
                }
                
                NavigationLink("플로깅 플레이") {
                }.buttonStyle(DefaultButton(isdisable: false))
                    .padding(.top)
                NavigationLink("히스토리") {
                }.buttonStyle(DefaultButton(isdisable: false))
                    .padding()
                Spacer().frame(height: 60)
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    dismissButton(sfName: "person.crop.circle") {
                        print("my info ...")
                    }
                }
            }
        }
    }
    
    // MARK: Flip Card Function
    func flipCard () {
        isFlipped.toggle()
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree = 0
            }
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct FrontView: View {
    @Binding var degree: Double
    
    var body: some View {
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
                
                    HStack {
                        Text("같이줍깅 가이드 보러가기 ")
                            .font(.Jamsil.light.font(size: 14))
                        
                        Image(systemName: "chevron.right")
                        
                    }
                    .foregroundColor(.init(hexCode: "#1A8370"))
                    .padding()

            }
        }
        .frame(width: 342, height: 450)
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 10, z: 0))
    }
}

struct BackView: View {
    @Binding var degree: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.white)
                .shadow(radius: 13)
            VStack(alignment: .leading, spacing: 33) {
                Text("같이줍깅 가이드")
                    .font(.Jamsil.bold.font(size: 20))
                HStack {
                    Image("onboarding_character")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .scaledToFit()
                        .background(
                            Circle()
                                .fill(Color.backgroundColor)
                                .frame(width: 65, height: 65)
                        )
                    Text("방장은 방을 생성한 후 \n팀원들에게 참여코드를 공유해요.")
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
                                .frame(width: 65, height: 65)
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
                                .frame(width: 65, height: 65)
                        )
                    Text("플로깅의 경험을 공유하기 위해 \n사진 미션을 수행해요. \n오늘의 플로깅 활동을 기록하고 \n공유할 수 있어요.")
                        .font(.Jamsil.light.font(size: 16))

                }
            }
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 10, z: 0))
        .frame(width: 342, height: 450)
    }
}
