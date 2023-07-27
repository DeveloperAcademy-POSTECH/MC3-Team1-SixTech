//
//  ImagePickView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/26.
//

import SwiftUI

struct ImagePickView: View {
    @State private var isdisable: Bool = true
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    // 미션
    var body: some View {
        VStack {
            Spacer()
            Text("미션 사진 고르기")
                .font(.Jamsil.bold.font(size: 20))
                .padding()
            Text("제일 맘에 드는 사진을\n미션결과로 골라요")
                .multilineTextAlignment(.center)
                .font(.Jamsil.light.font(size: 17))
                .padding(.bottom, 30)
            
            PolaroidView(selectedImage: $selectedImage, isdisable: $isdisable, profileImage: $profileImage)
            ButtonView(text: "골랐어요!", isdisable: $isdisable) {
                    // Navigation -> ShareResultView
            }
            .padding(.top, 100)
        }
    }
}

struct ImagePickView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickView()
    }
}
