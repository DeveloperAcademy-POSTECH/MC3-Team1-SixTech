//
//  ButtonStyle.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/13.
//

import Foundation
import SwiftUI

/*
 이슈가 있음.
 버튼스타일에 disable을 먹여도 버튼에 적용이 되질 않는다.
 여기서 변수를 받아 색깔을 바꾸고, 따로 또 코드에 disable을 따로 먹여야 하는 매우매우 귀찮은 상황.
 
 ->
 사용법 예제 (만약 disable이 필요 없을 경우 false 고정. 더 좋은 아이디어 있다면 의견을 내주세요 ㅠㅠ)
            private var isdisable: Bool {
                    (조건)
            }

            Button("Test") {
                print("SixTech")
            }.buttonStyle(DefaultButton(isdisable: isdisable))
             .disabled(isdisable)
 */

struct DefaultButton: ButtonStyle {
    @State var isdisable: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(width: 342, height: 76)
            .background(isdisable ? Color.disableColor : Color.defaultColor)
            .cornerRadius(36)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            .font(.Jamsil.bold.font(size: 24))
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}

struct SmallButton: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(width: 155, height: 48)
            .background(Color.defaultColor)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 4)
            .font(.Jamsil.regular.font(size: 17))
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}

struct CircleButton: ButtonStyle {

    @Binding var isTapped: Bool
    
    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .frame(width: 116, height: 116)
            .clipShape(Circle())
            .overlay(
        
                ZStack {
                    
                    Circle()
                        .foregroundColor(isTapped ? Color.disableColor.opacity(0.7) : .clear)
                    
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 4))
                    .foregroundColor(Color.defaultColor)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(Color.defaultColor)
                        .opacity(isTapped ? 1 : 0)
                }
                    )
            .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 4)
        
    }
}
