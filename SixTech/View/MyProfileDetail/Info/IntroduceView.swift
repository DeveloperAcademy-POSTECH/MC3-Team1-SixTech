//
//  IntroduceView.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/27.
//

import SwiftUI

struct LeftImageIntroduceView: View {
    var imagename: String
    var developer: String
    var title: String
    
    var body: some View {
        ZStack {
            HStack {
                Image(imagename)
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Spacer()
            }
            VStack(alignment: .center) {
                Text(title)
                    .font(.Jamsil.thin.font(size: 15))
                Text(developer)
                    .font(.Jamsil.regular.font(size: 20))
            }
        }
        .padding(.horizontal, 11)
    }
}

struct RightImageIntroduceView: View {
    var imagename: String
    var developer: String
    var title: String
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                Image(imagename)
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            VStack {
                Text(title)
                    .font(.Jamsil.thin.font(size: 15))
                    .multilineTextAlignment(.center)
                
                Text(developer)
                    .font(.Jamsil.regular.font(size: 15))
            }
        }
        .padding(.horizontal, 11)    }
}

struct IntroduceView_Previews: PreviewProvider {
    static var previews: some View {
        LeftImageIntroduceView(imagename: "", developer: "hello", title: "tired\nold")
    }
}
