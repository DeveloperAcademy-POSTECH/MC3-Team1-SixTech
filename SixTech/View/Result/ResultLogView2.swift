//
//  ResultLogView2.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/26.
//

import SwiftUI

struct ResultLogView2: View {
        
    // 플로깅 데이터
    @State var kcal: Int = 130
    @State var userkm: Double = 5.0
    @State var steps: Int =  13332
    @State var date: String = "2023.03.15"
    @State var ploogingCount: Int = 1233
    
    // 지도 이미지
    @State var mapImage: String = "usermap"
    
    // 유저 프로필 사진
    @State var userProfileImage: String = "userprofile"

    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundColor(.clear)
                .shadow(radius: 10, y: 4)
                .overlay(
                    Image(mapImage)
                )

            // 데이터 부분
            VStack {
                
                HStack {
                    Text(date)
                        .font(.Jamsil.medium.font(size: 16))
                        .shadow(radius: 2, y: 1)
                    
                    Spacer()
                    
                    Image(userProfileImage)
                        .resizable()
                        .frame(width: 36, height: 36)
                    
                }
                .padding(.horizontal)
                .foregroundColor(.white)
                
                HStack {
                    
                    Spacer()
                    
                    Text("같이줍깅")
                        .foregroundColor(.white)
                        .font(.Jamsil.light.font(size: 12))
                        
                }
                .padding(.trailing)
                
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
                .shadow(radius: 2, y: 1)
                .foregroundColor(.white)
                .padding(.bottom)
                
            }
                
        }
        .frame(width: 320, height: 337)
    }
    
}

struct ResultLogView2_Previews: PreviewProvider {
    static var previews: some View {
        ResultLogView2()
    }
}
