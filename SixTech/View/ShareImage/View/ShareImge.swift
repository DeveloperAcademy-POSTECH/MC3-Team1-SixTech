//
//  ShareImge.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/27.
//

import SwiftUI
import UIKit
import Photos

struct ShareImageView: View {
    @State var currentIndex: Int = 0
    @State var images: [ShareImage]
//    @State var sizeToImage: CGSize = CGSize(width: 0, height: 0)
    @State var isButtonPressed: Bool = false
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                ImageButton(image: .right) {
                    print("")
                }
                .padding(.trailing)
            }
            
            Text("플로깅이 끝났어요.")
                .font(.Jamsil.bold.font(size: 20))
            Text("미션결과를 팀원들과 공유해요.")
                .font(.Jamsil.light.font(size: 17))
            
            Text("\(currentIndex+1) / \(images.count)")
                .font(.Jamsil.light.font(size: 17))
                .padding()
            
            SnapCarousel(index: $currentIndex, items: images) { image in
                
                PolaroidView(isdisable: .constant(false), profileImage: .constant(image.postImage), userName: .constant("User"), userMission: .constant("Mision"), isButtonPressed: $isButtonPressed)
//                .background(
//                    GeometryReader { proxy in
//                        Color.red
//                            .preference(key: SizePreferenceKey.self, value: proxy.size)
//                            .onAppear {
//                                sizeToImage = CGSize(width: proxy.size.width, height: proxy.size.height)
//                            }
//                    })
            }
            
            Spacer()
            
            ButtonView(text: "로렌조가 만든 버튼으로 바꿀예정", isdisable: .constant(false)) {
                isButtonPressed.toggle()
            }
            .padding(.top, 100)
            
        }
        .navigationBarBackButtonHidden()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ShareImageView(images: [
            ShareImage(postImage: Image("MissionTestImage")),
            ShareImage(postImage: Image("MissionTestImage")),
            ShareImage(postImage: Image("MissionTestImage")),
            ShareImage(postImage: Image("MissionTestImage")),
            ShareImage(postImage: Image("MissionTestImage"))
        ])
    }
}


//                let renderer = ImageRenderer(content: PolaroidView(isdisable: .constant(false), profileImage: Binding.constant(images[currentIndex].postImage), userName: .constant("User"), userMission: .constant("Mision")))
//
//                if let image = renderer.uiImage {
//                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//                }
