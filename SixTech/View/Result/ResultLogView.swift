//
//  ResultLogStyle.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/26.
//

import SwiftUI

struct ResultLogView: View {
    
    // 플로깅 데이터
    @State var kcal: Int = 130
    @State var userkm: Double = 5.0
    @State var steps: Int =  13332
    @State var date: String = "2023.03.15"
    @State var ploogingCount: Int = 1233
    
    // 플로깅 중 찍은 사진
    @State var userImage: String = "ploggingphoto"
    
    // 유저 프로필 사진
    @State var userProfileImage: String = "userprofile"
    
    var body: some View {
    
            ZStack(alignment: .top) {
                
                Rectangle()
                    .foregroundColor(.white)
                    .shadow(radius: 10, y: 1)
                
                Image(userImage)
                    .resizable()
                    .frame(width: 294, height: 294)
                    .padding(.top)
                
                VStack {
                    
                    Spacer()
                    
                    Rectangle()
                        .foregroundColor(.white)
                    .frame(height: 90)
                    
                }
                
                VStack {
                    Spacer()
                    
                    ZStack(alignment: .center) {
                        
                        Circle()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white)
                        
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .overlay(
                                Image(userProfileImage)
                                    .resizable()
                                    .scaledToFit()
                            )
                    }
                    .padding(.bottom, 50)
                    
                }
                
                // 데이터 부분
                VStack {
                
                    HStack {
                        Text(date)
                            .font(.Jamsil.medium.font(size: 16))
                            .foregroundColor(.white)
                            .shadow(radius: 2, y: 1)
                        
                        Spacer()
                        
                    }
                    .padding(.leading, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    HStack {

                        Spacer()
                        
                        VStack {
                            Text("\(userkm)")
                                .font(.Jamsil.medium.font(size: 20))
                            
                            Text("km")
                                .font(.Jamsil.light.font(size: 12))
                            
                        }
                        Spacer()
                        
                        VStack {
                            Text("\(steps)")
                                .font(.Jamsil.medium.font(size: 20))
                            
                            Text("steps")
                                .font(.Jamsil.light.font(size: 12))
                            
                        }

                        Spacer()
                        
                        VStack {
                            Text("\(ploogingCount)")
                                .font(.Jamsil.medium.font(size: 20))
                            
                            Text("줍깅")
                                .font(.Jamsil.light.font(size: 12))
                            
                        }

                        Spacer()
                        
                        VStack {
                            Text("\(kcal)")
                                .font(.Jamsil.medium.font(size: 20))
                            
                            Text("kcal")
                                .font(.Jamsil.light.font(size: 12))
                            
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.bottom, 12)
                    
                }
            }
            .frame(width: 320, height: 337)
        }

}

struct ResultLogStyle_Previews: PreviewProvider {
    static var previews: some View {
        ResultLogView()
    }
}
