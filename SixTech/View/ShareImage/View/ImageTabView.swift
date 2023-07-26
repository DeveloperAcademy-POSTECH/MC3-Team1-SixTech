//
//  ImageTabView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/26.
//

import SwiftUI

struct ImageTabView: View {
    
    @Binding var selectedTab: Int
    let images: [Image]
    @State private var offset = CGFloat.zero
    var imageCount: Int { images.count }
    
    var body: some View {
        
        VStack {
            
        }
    }
}

struct ImageTabView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTabView(selectedTab: Binding.constant(1), images: [Image("face_dust_gray")])
    }
}

//        images[0]
//            .resizable()

// TeasingTabView(selectedTab: $selected, spacing: 20) {
//            [
//                Rectangle()
//                ]
//        }
