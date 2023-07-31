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
    @State private var selectedIndex = 1
    @Binding var currentIndex: Int
    @Binding var capturedImage: UIImage?
    
    var itemWidth: CGFloat
    var spacing: CGFloat
    var trailingSpace: CGFloat
    
    init(capturedImage: Binding<UIImage?>, currentIndex: Binding<Int>, spacing: CGFloat, trailingSpace: CGFloat, itemWidth: CGFloat) {
        _capturedImage = capturedImage
        _currentIndex = currentIndex
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self.itemWidth = itemWidth
    }
    
    let baseFilters = ["2D", "기본", "3D"]
    var filters: [String] {
        Array(repeating: baseFilters, count: 20).flatMap { $0 }
    }
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { value in
                    LazyHStack(alignment: .bottom, spacing: spacing) {
                        ForEach(0..<filters.count, id: \.self) { index in
                            GeometryReader { itemGeometry in
                                let ratio = getRatio(for: itemGeometry, in: geometry)
                                Button(action: {
                                    if currentIndex == index {
                                        takeScreenshotAndSave()
                                        feedbackGenerator.notificationOccurred(.success)
                                    } else {
                                        currentIndex = index
                                    }
                                }) {
                                    VStack{
                                        let isSelected = (currentIndex == index)
                                        Circle()
                                            .overlay(
                                                Image(filters[index % baseFilters.count])
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 50, height: 50)
                                            )
                                            .overlay(getButtonOverlay(for: index, ratio: ratio, isSelected: currentIndex == index))
                                        Text(filters[index])
                                            .font(.Jamsil.light.font(size: 15))
                                            .foregroundColor(.white)
                                            .padding(.top, 5)
                                    }
                                }
                                .frame(width: itemWidth, height: itemWidth)
                                .foregroundColor(Color.white)
                                .id(index)
                                .position(x: itemGeometry.size.width/2, y:itemGeometry.size.height/2)
                            }
                            .frame(width: geometry.size.width / 2.8)
                        }
                    }
                    .padding(.top, 20)
                    .background(Color.black)
                    .onChange(of: currentIndex) { _ in
                        value.scrollTo(currentIndex, anchor: .center)
                    }
                }
            }
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
            .scrollDisabled(true)
        }
        .onAppear {
            DispatchQueue.main.async {
                currentIndex = baseFilters.firstIndex(of: "기본") ?? 0
                selectedIndex = baseFilters.count
            }
        }
    }
   
    func getRatio(for itemGeometry: GeometryProxy, in geometry: GeometryProxy) -> CGFloat {
        let itemFrame = itemGeometry.frame(in: .global)
        let scrollViewFrame = geometry.frame(in: .global)
        let distanceFromCenter = abs((itemFrame.midX - scrollViewFrame.midX))
        let ratio = 1 - (distanceFromCenter / scrollViewFrame.width / 2)
        
        return ratio
    }

    func getButtonSize(for index: Int, ratio: CGFloat, isSelected: Bool) -> CGFloat {
        let minSize: CGFloat = 55
        let maxSize: CGFloat = 75
        if isSelected || (ratio > 0.95) {
            return maxSize * ratio
        } else {
            return minSize * ratio
        }
    }

    func getButtonOverlay(for index: Int, ratio: CGFloat, isSelected: Bool) -> some View {
        return Circle()
            .stroke(lineWidth: (isSelected || (ratio > 0.95) ? 5 : 0))
            .frame(width: (isSelected || (ratio > 0.95)) ? 90 : 0, height: (isSelected || (ratio > 0.95)) ? 90 : 0)
            .foregroundColor(Color.backgroundColor)
    }

    func takeScreenshotAndSave() {
        print("takeScreenshotAndSave")
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0)
            rootViewController.view.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
            let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let fullScreenshot = fullScreenshot {
                let scale = fullScreenshot.scale
                let cropRect = CGRect(x: 0,
                                      y: (fullScreenshot.size.height / 6) * scale,
                                      width: fullScreenshot.size.width * scale,
                                      height: (fullScreenshot.size.width * scale))
                if let croppedImage = fullScreenshot.cgImage?.cropping(to: cropRect) {
                    let croppedUIImage = UIImage(cgImage: croppedImage, scale: scale, orientation: .up)
                    UIImageWriteToSavedPhotosAlbum(croppedUIImage, nil, nil, nil)
                }
            }
        }
    }
}

struct FilterCarouselView_Previews: PreviewProvider {
    @State static var dummyImage: UIImage? = nil
    @State static var currentIndex: Int = 2
    
    static var previews: some View {
        FilterCarouselView(capturedImage: $dummyImage, currentIndex: $currentIndex, spacing: 10, trailingSpace: 20, itemWidth: 100)
    }
}
