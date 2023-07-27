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

// 일반 버튼
struct ButtonView: View {
    let text: String
    @Binding var isdisable: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            ButtonLabel(text: text, isdisable: $isdisable)
        }
        .disabled(isdisable)
    }
}

// NavigationLink 버튼
struct NavigationLinkView<Destination: View>: View {
    let text: String
    @Binding var isdisable: Bool
    let destination: Destination

    var body: some View {
        NavigationLink {
            destination
        } label: {
            ButtonLabel(text: text, isdisable: $isdisable)
        }
        .disabled(isdisable)
    }
}

// 버튼 모양
struct ButtonLabel: View {
    let text: String
    @Binding var isdisable: Bool
    var body: some View {
        Rectangle()
            .cornerRadius(36)
            .frame(height: 76)
            .padding()
            .foregroundColor(isdisable ? Color.disableColor : Color.defaultColor)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            .overlay {
                Text(text)
                    .foregroundColor(.white)
                    .font(.Jamsil.bold.font(size: 24))
            }
    }
}

struct ButtonTest_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                ButtonView(text: "Test", isdisable: Binding.constant(false)) {
                    print("Test")
                }
                
                NavigationLinkView(text: "TestNav", isdisable: Binding.constant(false), destination: CharacterCreateView())
            }
        }
    }
}
