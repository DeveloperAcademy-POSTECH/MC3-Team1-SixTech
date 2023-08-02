//
//  PolaroidView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/26.
//

import SwiftUI

struct PolaroidView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var matchManager: MatchManager
    
    @Binding var isButtonPressed: Bool
    @Binding var isdisable: Bool
    
    let viewModel = CharacterCreateViewModel()
    
    var userName: String
    var userMission: String
    var image: Image?
    var uiimage: UIImage?
    var profileImage: [Int]?
    
        var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0)
                
                VStack {
                    Group {
                        if isdisable {
                            Rectangle()
                                .foregroundColor(.beforeImagePickColor)
                                .overlay {
                                    VStack {
                                        Image(systemName: "photo")
                                            .font(.system(size: 40))
                                            .padding()
                                        Text("사진 추가하기...")
                                            .font(.system(size: 17))
                                        
                                    }
                                    .foregroundColor(.beforeImagePickTextColor)
                                }
                        } else {
                            if let image = uiimage {
                                Image(uiImage: image)
                                    .resizable()
                            } else {
                                image!
                                    .resizable()
                            }
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.all, 12)
                    HStack(alignment: .center) {
                        ZStack {
                            Circle()
                                .foregroundColor(.backgroundColor)
                                .frame(width: 40, height: 40)
                            if let image = profileImage {
                                Image(uiImage: viewModel.imageMerger.merge("\(viewModel.faceArray[image[0]] + viewModel.colorArray[image[1]])", with: "\(viewModel.emotionArray[image[2]])"))
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            } else {
                                Image(uiImage: loadImageFromURL(imageURL: userInfo.profileImageURL))
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            }
                        }
                        
                        Text(userName)
                            .foregroundColor(.black)
                            .font(.Jamsil.light.font(size: 17))
                    }
                    Text(userMission)
                        .foregroundColor(.black)
                        .font(.Jamsil.light.font(size: 20))
                    Spacer()
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.width * 4 / 3)
            .aspectRatio(3/4, contentMode: .fit)
            .onChange(of: isButtonPressed) { _ in
                if isButtonPressed == true {
                    isButtonPressed.toggle()
                    screenShot()
                }
            }
            
        }
    }

//    struct PolaPreview: PreviewProvider {
//        static var previews: some View {
//            PolaroidView(userInfo: "User", matchManager: .constant(false), isButtonPressed: "Mision", isdisable: Image("GU1"), userName: .constant(false))
//                .environmentObject(MatchManager())
//                .environmentObject(UserInfo())
//        }
//    }

    extension UIView {
        var screenShot: UIImage {
            let rect = self.bounds
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
            let context: CGContext = UIGraphicsGetCurrentContext()!
            self.layer.render(in: context)
            let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            return capturedImage
        }
    }

    // View에 ScreenShot을 넣기 위함
    extension View {
        func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
            let window = UIWindow(frame: CGRect(origin: origin, size: size))
            // UIHostingController: SwiftUI View들을 관리하기 위한 ViewController
            let hosting = UIHostingController(rootView: self)
            hosting.view.frame = window.frame
            window.addSubview(hosting.view)
            window.makeKeyAndVisible()
            return hosting.view.screenShot
        }
    }

    extension PolaroidView {
        func screenShot() {
            let screenshot = body.takeScreenshot(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size)
                .resizeAndCrop(to: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 4 / 3))!
            
            UIImageWriteToSavedPhotosAlbum(screenshot, self, nil, nil)
        }
    }
