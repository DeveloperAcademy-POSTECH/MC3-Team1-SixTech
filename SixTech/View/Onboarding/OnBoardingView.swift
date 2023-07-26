//
//  OnBoardingView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/13.
//

import SwiftUI
import SwiftUIGIF

struct OnBoardingView: View {
    @State private var currentPage = 1
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $currentPage) {
                    OnBoarding1View()
                        .tag(1)
                    OnBoarding2View()
                        .tag(2)
                    OnBoarding3View()
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .padding(.top, 50)
                
                PageTabViewStyle(pageNumber: currentPage, totalPageNumber: 3)
                NavigationLinkView(text: "확인했어요", isdisable: Binding.constant(false), destination: CharacterCreateView())
            }
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}

// NavigationLink("확인했어요") {
//    CharacterCreateView()
// }.buttonStyle(DefaultButton(isdisable: false))
