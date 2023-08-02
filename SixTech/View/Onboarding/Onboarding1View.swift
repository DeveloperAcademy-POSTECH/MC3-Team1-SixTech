//
//  Onboarding1View.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/20.
//

import SwiftUI
import SwiftUIGIF

struct OnBoarding1View: View {
    var body: some View {
        VStack {
			Group {
				Text("나의 플로깅 발자취를 한눈에")
				Text("")
			}
			.font(.Jamsil.regular.font(size: 20))
			
            Spacer()
          Image("onboarding1img")
				.resizable()
				.scaledToFit()
        }
    }
}

struct OnBoarding1View_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding1View()
    }
}
