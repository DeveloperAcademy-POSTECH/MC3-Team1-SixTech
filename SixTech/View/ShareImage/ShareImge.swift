//
//  ShareImge.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/27.
//

import SwiftUI
import UIKit

struct ShareImgeView: View {
    
    @State var currentIndex: Int = 0
    @State var images: [ShareImage]
    @State var currectTab = "Slide Show"
    @Namespace var animation
//    @State var capture: NSImage?
    
    func saveImageToPhotos(image: UIImage) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                ImageButton(image: .right) {
                    print("")
                }
                .padding(.leading)
            }
            
            Text("플로깅이 끝났어요.")
                .font(.Jamsil.bold.font(size: 20))
            Text("미션결과를 팀원들과 공유해요.")
                .font(.Jamsil.light.font(size: 17))
            
            Text("\(currentIndex+1) / \(images.count)")
                .font(.Jamsil.light.font(size: 17))
                .padding()
            
            SnapCarousel(index: $currentIndex, items: images) { image in
                
                GeometryReader { proxy in
                    let size = proxy.size
                    PolaroidView(isdisable: .constant(false), profileImage: Binding.constant(image.postImage), userMission: .constant("Mision"))
                        .frame(width: size.width)
                    
                }
            }
            
            Spacer()
            
            ButtonView(text: "로렌조가 만든 버튼으로 바꿀예정", isdisable: .constant(false)) {
                
            }
            .padding(.top, 100)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ShareImgeView(images: [
            ShareImage(postImage: Image("face_dust_gray")), // Replace with your image names or URLs
                        ShareImage(postImage: Image("face_dust_yellow")),
                        ShareImage(postImage: Image("face_can_gray")),
                        ShareImage(postImage: Image("face_bag_yellow")),
                        ShareImage(postImage: Image("face_pet_gray"))
        ])
    }
}

struct SnapshotSaver<Content: View>: UIViewRepresentable {
    let content: Content

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400)) // 크기를 조정하거나 뷰에 맞게 설정
        view.addSubview(UIHostingController(rootView: content).view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Nothing to do here
    }
}
