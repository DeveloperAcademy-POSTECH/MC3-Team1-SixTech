//
//  SelectFoodView.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/28.
//

import SwiftUI

struct SelectFoodView: View {
    @State private var foods = [
        Food(emoji: "🥑", name: "아보카도", kcal: "250kcal", kcalInt: 250),
           Food(emoji: "🌮", name: "타코", kcal: "200kcal", kcalInt: 200 ),
           Food(emoji: "🍎", name: "사과", kcal: "100kcal", kcalInt: 100),
           Food(emoji: "🍺", name: "맥주 500ml", kcal: "200kcal", kcalInt: 200),
           Food(emoji: "🍜", name: "라멘", kcal: "600kcal", kcalInt: 600),
           Food(emoji: "🍦", name: "아이스크림", kcal: "200kcal", kcalInt: 200),
           Food(emoji: "🍔", name: "햄버거", kcal: "450kcal", kcalInt: 450),
           Food(emoji: "🍕", name: "피자", kcal: "300kcal", kcalInt: 300)
       ]
       
    @State private var selectedFoodIndex: Int? = nil
    
    let columns = [
            // 추가 하면 할수록 화면에 보여지는 개수가 변함
            GridItem(.flexible(), spacing: nil, alignment: nil),
            GridItem(.flexible(), spacing: nil, alignment: nil)
        ]
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button {
                        
                    } label: {
                        
                        // 버튼 배경색이 아직 안들어와있어서 회색으로 대체...
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.defaultColor)
                            .padding()
                            .background(Color.gray)
                            .clipShape(Circle())
                }
                    Spacer()
                }
                
                Text("칼로리 기준")
                    .font(.Jamsil.medium.font(size: 20))
            }
            .padding(.bottom)
            
            Text("좋아하는 음식으로 칼로리를 계산해줄게요.")
                .font(.Jamsil.regular.font(size: 17))
            
            Text("음식 1개 기준 대략적인 칼로리입니다:)")
                .font(.Jamsil.thin.font(size: 14))
                .padding(.bottom)
            
            HStack {
                LazyVGrid(columns: columns) {
                    ForEach(foods) { food in
                        Button {
                            selectFood(food)
                        } label: {
                            FoodCardView(isSelected: Binding(
                                get: { food.isSelected },
                                set: { isSelected in
                                    if isSelected {
                                        selectFood(food)
                                    }
                                }
                            ), foodEmoji: food.emoji, foodName: food.name, foodKcal: food.kcal)
                        }
                        .padding(.bottom)
                    }
                }
            }
            .padding(.top)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("선택하기")
            }
            .buttonStyle(DefaultButton(isdisable: false))
        }
        .padding(.horizontal, 24)
        .padding(.bottom)
    }
    
    private func selectFood(_ selectedFood: Food) {
        for index in foods.indices {
            foods[index].isSelected = foods[index].id == selectedFood.id
        }
    }
}

struct Food: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let kcal: String
    let kcalInt: Int
    var isSelected: Bool = false
}

struct SelectFoodView_Previews: PreviewProvider {
    static var previews: some View {
        SelectFoodView()
    }
}
