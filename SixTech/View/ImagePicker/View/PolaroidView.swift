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
                Text("\(UserDefaults.standard.string(forKey: "username") ?? "")")
                Text("Plz add Mission")
                Spacer()
            }
        }
    }
}
