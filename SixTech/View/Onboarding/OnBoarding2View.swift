//
//  OnBoarding2View.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/13.
//

import SwiftUI

struct OnBoarding2View: View {
    var body: some View {
        VStack {
            Text("사람들과 함께 플로깅하고,\n함께 축하해요.")
                .multilineTextAlignment(.center)
                .font(.Jamsil.regular.font(size: 20))
            Spacer()
            Image("onboarding2img")
				.resizable()
				.scaledToFit()
				.padding(.bottom)
        }
    }
}

struct OnBoarding2View_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding2View()
    }
}
