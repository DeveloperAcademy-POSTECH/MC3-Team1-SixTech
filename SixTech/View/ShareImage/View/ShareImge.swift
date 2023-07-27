//
//  ShareImge.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/27.
//

import SwiftUI

struct ShareImgeView: View {
    
    @State var currentIndex: Int = 0
    @State var images: [ShareImage]
    
    @State var currectTab = "Slide Show"
    @Namespace var animation
    
    var body: some View {
        
        VStack {
            Text("\(currentIndex+1) / \(images.count)")
            // SnapCarousel
            SnapCarousel(index: $currentIndex, items: images) { image  in
                
                GeometryReader { proxy in
                    let size = proxy.size
                    PolaroidView(isdisable: .constant(false), profileImage: $images[0].postImage)
                        .frame(width: size.width)
                }
            }
            .padding(.vertical, 40)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ShareImgeView(images: [
            ShareImage(postImage: Image("face_dust_gray")), // Replace with your image names or URLs
                        ShareImage(postImage: Image("face_dust_gray")),
                        ShareImage(postImage: Image("face_dust_gray")),
                        ShareImage(postImage: Image("face_dust_gray")),
                        ShareImage(postImage: Image("face_dust_gray"))
        ])
    }
}
