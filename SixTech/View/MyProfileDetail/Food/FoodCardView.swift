//
//  FoodCardView.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/28.
//

import SwiftUI

struct FoodCardView: View {
    
    // 사용자가 해당 음식을 골랐는지의 여부에 따라 색이 바뀝니다
    @Binding var isSelected: Bool
    
    var foodEmoji: String
    var foodName: String
    var foodKcal: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(isSelected ? .white : .backgroundColor) // 여기도 색이 없어서 일단 흰색으로 해뒀습니다
                .shadow(radius: 10, y: 1)
            
            HStack {
                Text(foodEmoji)
                    .font(.system(size: 50))
                VStack {
                    Text(foodName)
                        .font(.Jamsil.regular.font(size: 16))
                        .foregroundColor(.black)
                    
                    Text(foodKcal)
                        .font(.Jamsil.light.font(size: 14))
                        .foregroundColor(.black)
                }
            }
        }
        .frame(width: 142, height: 62)
    }
}
