//
//  OnBoarding2View.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/13.
//

import SwiftUI

struct OnBoarding2View: View {
    let circleSize: CGFloat = 15
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("사람들과 함께 플로깅하고,\n함께 축하해요")
                    .multilineTextAlignment(.center)
                    .font(.Jamsil.regular.font(size: 24))
                
                VStack {
                    Image("onboarding_gourd")
                    Image("onboarding_character")
                }
                .frame(height: geometry.size.height/1.6)
                
                PageTabViewStyle(pageNumber: 2)
                Spacer()
                NavigationLink("확인했어요") {
                    OnBoarding3View()
                }.buttonStyle(DefaultButton(isdisable: false))
                
            }
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
            .navigationBarBackButtonHidden()
        }
    }
}

struct OnBoarding2View_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding2View()
    }
}
