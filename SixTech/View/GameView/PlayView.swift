//
//  MainView.swift
//  SixTech
//
//  Created by 주환 on 2023/07/20.
//

import SwiftUI
import SwiftUIGIF

struct PloggingPlayView: View {
    @EnvironmentObject var matchManager: MatchManager
    @Environment(\.dismiss) var dismiss
    
    @State private var isFlipped = true
    @State private var backDegree = 90.0
    @State private var frontDegree = 0.0
    
    private let durationAndDelay: CGFloat = 0.3
    
    var body: some View {
        VStack {
            Text("플로깅 플레이")
                .font(.Jamsil.bold.font(size: 20))
            
            ZStack {
                FrontView(degree: $frontDegree)
                    .padding(.top)
                BackView(degree: $backDegree)
                    .padding(.top)
            }.onTapGesture {
                flipCard()
            }
            
            NavigationLink("방 만들기") {
                CreateRoomView()
            }.buttonStyle(DefaultButton(isdisable: false))
                .padding(.top)
            NavigationLink("참여하기") {
                EngagementView()
            }.buttonStyle(DefaultButton(isdisable: false))
                .padding()
            Spacer().frame(height: 60)
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                dismissButton(sfName: "chevron.backward") {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
        
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

struct PloggingPlayView_Previews: PreviewProvider {
    static var previews: some View {
        PloggingPlayView()
            .environmentObject(MatchManager())
    }
}

struct FrontView: View {
    @Binding var degree: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.background2Color)
                .shadow(radius: 13)
            VStack {
                GIFImage(name: "OnboardingGIF")
                    .scaledToFill()
                    .frame(width: 300, height: 300)
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
                    Image("GU1")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .scaledToFill()
                    Text("방장은 방을 생성한 후 \n팀원들에게 참여코드를 공유해요.")
                        .font(.Jamsil.light.font(size: 16))

                }
                HStack {
                    Image("GU2")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .scaledToFill()
                    Text("팀원들은 참여코드를 입력하여\n플로깅 팀에 참여해요.")
                        .font(.Jamsil.light.font(size: 16))

                }
                HStack {
                    Image("GU3")
                        .resizable()
                        .frame(width: 46, height: 47)
                        .scaledToFit()
                        .clipped()
                        .background(
                            Circle()
                                .fill(Color.backgroundColor)
                                .frame(width: 60, height: 60)
                        )
                    Text("플로깅의 경험을 공유하기 위해 \n사진 미션을 수행해요.")
                        .font(.Jamsil.light.font(size: 16))
                        .padding(.leading, 10)
                }.padding(.leading, 7)
            }
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 10, z: 0))
        .frame(width: 342, height: 450)
    }
}
