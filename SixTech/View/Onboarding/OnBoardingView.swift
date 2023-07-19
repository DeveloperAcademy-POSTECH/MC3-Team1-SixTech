//
//  OnBoardingView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/13.
//

import SwiftUI
import SwiftUIGIF

struct OnBoardingView: View {
    let circleSize: CGFloat = 15
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Spacer()
                        Text("나의 플로깅 발자취를 한눈에\n ")
                        .font(.Jamsil.regular.font(size: 24))
                    Spacer()
                    
                    VStack {
                        GIFImage(name: "OnboardingGIF")
                        PageTabViewStyle(pageNumber: 1)
                    }
                    .frame(height: geometry.size.height/1.6)
                        
                    Spacer()
                    NavigationLink("확인했어요") {
                        OnBoarding2View()
                    }.buttonStyle(DefaultButton(isdisable: false))
                }
            }.navigationBarBackButtonHidden()
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
