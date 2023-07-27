//
//  PolaroidView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/26.
//

import SwiftUI

struct PolaroidView: View {
    @Binding var isdisable: Bool
    @Binding var profileImage: Image?
    @Binding var userName: String?
    @Binding var userMission: String?
    @AppStorage("profileURL") var profileImageURL: URL = UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "")!
    
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
                        profileImage!
                            .resizable()
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(.all, 12)
                HStack(alignment: .center) {
                    ZStack {
                        Circle()
                            .foregroundColor(.backgroundColor)
                            .frame(width: 40, height: 40)
                        Image(uiImage: loadImageFromURL(imageURL: profileImageURL))
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    
                    Text(userName ?? "")
                }
                Text(userMission ?? "")
                Spacer()
            }
        }
    }
}
