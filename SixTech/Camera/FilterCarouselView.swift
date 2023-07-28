//
//  FilterCarouselView.swift
//  earth2
//
//  Created by 신정연 on 2023/07/27.
//
import SwiftUI
import PhotosUI

extension UIView {
    func asImage(in rect: CGRect) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(bounds: rect, format: format).image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func takeScreenshotAndSaveToAlbum(in rect: CGRect) {
        let image = self.asImage(in: rect)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

struct FilterCarouselView: View {
    @State private var width: CGFloat = 0
    @Binding var capturedImage: UIImage?
    @State private var selectedIndex = 1
    @State private var isButtonClicked = false
    @State private var dragOffset: CGFloat = 0
    @GestureState private var offset: CGFloat = 0
    @Binding var currentIndex: Int

    var spacing: CGFloat
    var trailingSpace: CGFloat
    
    init(capturedImage: Binding<UIImage?>, currentIndex: Binding<Int>, spacing: CGFloat, trailingSpace: CGFloat) {
        _capturedImage = capturedImage
        _currentIndex = currentIndex // Initialize with binding from parent view
        self.spacing = spacing
        self.trailingSpace = trailingSpace
    }
    
    let filters = ["2d", "3d", "기본", "2d", "3d", "기본"]
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 1) {
                    ForEach(0..<filters.count, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                if selectedIndex == index && isButtonClicked {
                                    takeScreenshotAndSave()
                                    feedbackGenerator.notificationOccurred(.success)
                                    isButtonClicked = false
                                    
                                } else {
                                    selectedIndex = index
                                    isButtonClicked = true
                                    currentIndex = index
                                }
                            }
                        }) {
                            VStack{
                                Circle()
                                    .frame(width: getButtonSize(for: index), height: getButtonSize(for: index))
                                
                                    .overlay(
                                        Image(filters[index])
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                        
                                    )
                                    .overlay(getButtonOverlay(for: index))
                                Text(filters[index % (filters.count / 2)])
                                    .font(.Jamsil.light.font(size: 15))
                                
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                            }
                            .frame(width: geometry.size.width / 3)
                            .offset(x: self.dragOffset)
                            .gesture(DragGesture()
                                .onChanged({ (value) in
                                    self.dragOffset = value.translation.width
                                })
                                    .onEnded({ (value) in
                                        withAnimation {
                                            self.dragOffset = 0
                                        }
                                        if index == self.selectedIndex {
                                            self.feedbackGenerator.notificationOccurred(.success)
                                        }
                                    })
                            )
                        }
                        .foregroundColor(Color.white)
                    }
                }
                .padding(.top, 20)
                .background(Color.black)
            }
        }
        .gesture(
            DragGesture()
                .updating($offset, body: { value, out, _ in
                    out = value.translation.width
                })
                .onEnded({ value in
                    let offsetX = value.translation.width
                    let progress = -offsetX / width
                    let roundIndex = (progress * CGFloat(filters.count - 1)).rounded()
                    
                    withAnimation {
                        currentIndex = max(min(Int(roundIndex), filters.count - 1), 0)
                    }
                    print("Current Index in FilterCarouselView is now: \(currentIndex)")
                })
        )
    }
    
    func getButtonSize(for index: Int) -> CGFloat {
        return selectedIndex == index ? 75 : 55
    }
    
    func getButtonOverlay(for index: Int) -> some View {
        return Circle()
            .stroke(lineWidth: selectedIndex == index ? 5 : 0)
            .frame(width: selectedIndex == index ? 90 : 0, height: selectedIndex == index ? 90 : 0)
            .foregroundColor(Color.backgroundColor)
    }
    
    func takeScreenshotAndSave() {
        print("takeScreenshotAndSave")
        if isButtonClicked {
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                // 화면 크기로 그래픽 컨텍스트 생성
                UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0)
                
                // 전체 뷰 계층 구조를 현재 컨텍스트에 렌더링
                rootViewController.view.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
                
                // 스크린샷 이미지 가져오기
                let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
                
                // 그래픽 컨텍스트 종료
                UIGraphicsEndImageContext()
                
                if let fullScreenshot = fullScreenshot {
                    let scale = fullScreenshot.scale
                    let cropRect = CGRect(x: 0,
                                          y: (fullScreenshot.size.height / 6) * scale,
                                          width: fullScreenshot.size.width * scale,
                                          height: (fullScreenshot.size.width * scale))
                    if let croppedImage = fullScreenshot.cgImage?.cropping(to: cropRect) {
                        let croppedUIImage = UIImage(cgImage: croppedImage, scale: scale, orientation: .up)
                        
                        // 잘린 스크린샷을 앨범에 저장
                        UIImageWriteToSavedPhotosAlbum(croppedUIImage, nil, nil, nil)
                    }
                }
                
            }
            
            isButtonClicked = false
        }
    }
    
    
}

struct FilterCarouselView_Previews: PreviewProvider {
    @State static var dummyImage: UIImage? = nil
    @State static var currentIndex: Int = 2
    
    static var previews: some View {
        FilterCarouselView(capturedImage: $dummyImage, currentIndex: $currentIndex, spacing: 10, trailingSpace: 20)
    }
}
