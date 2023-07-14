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
            .font(.custom("TheJamsilOTF5Bold", size: 24)) // 나중에 폰트 적용시켜야함
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}
