//
//  OnBoarding3View.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/13.
//

import SwiftUI
import SwiftUIGIF

struct OnBoarding3View: View {
    let circleSize: CGFloat = 15
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("같이줍깅은 애플워치가 있다면\n더 좋아요")
                    .multilineTextAlignment(.center)
                    .font(.Jamsil.regular.font(size: 24))
                Spacer()
                
                VStack {
                    GIFImage(name: "OnboardingGIF")
                    PageTabViewStyle(pageNumber: 3)
                }
                .frame(height: geometry.size.height/1.6)
                
                Spacer()
                NavigationLink("확인했어요") {
                    OnBoardingView()
                }.buttonStyle(DefaultButton(isdisable: false))
                
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct OnBoarding3View_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding3View()
    }
}
