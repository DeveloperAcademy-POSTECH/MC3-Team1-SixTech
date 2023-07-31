//
//  OnBoarding3View.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/13.
//

import SwiftUI
import SwiftUIGIF

struct OnBoarding3View: View {
    var body: some View {
        VStack {
            Text("같이줍깅은 애플워치가 있다면\n더 좋아요")
                .multilineTextAlignment(.center)
                .font(.Jamsil.regular.font(size: 20))
            Spacer()
//            GIFImage(name: "OnboardingGIF")
            GIFImage(name: "")
        }
    }
}

struct OnBoarding3View_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding3View()
    }
}
