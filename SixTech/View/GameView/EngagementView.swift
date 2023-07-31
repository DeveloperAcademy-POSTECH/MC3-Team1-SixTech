//
//  EngagementView.swift
//  SixTech
//
//  Created by 주환 on 2023/07/18.
//

import SwiftUI

struct EngagementView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var matchManager: MatchManager
    
    @State private var numberText = "    "
    @State var isDisable = true
    
    var body: some View {
        
        VStack {
            Text("참여코드를 입력하세요.")
                .font(.Jamsil.bold.font(size: 30))
                .padding()
            Text("같이줍깅은 참여코드가 필요해요.")
                .font(.Jamsil.light.font(size: 17))
            
            CustomTextField(text: $numberText)
                .textFieldStyle(.roundedBorder)
                .padding()
                .frame(width: 240)
            
            CustomNumberPad(text: $numberText)
                .padding()
            NavigationLinkView(text: "참여하기", isdisable: $isDisable, destination: WaitingRoomView(groupCode: numberText))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                dismissButton(sfName: "chevron.backward") {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onChange(of: numberText) { newValue in
            isDisable = newValue.containsWhitespace()
            print("\(isDisable)")
        }
    }
}

struct EngagementView_Previews: PreviewProvider {
    static var previews: some View {
        EngagementView()
            .environmentObject(MatchManager())
    }
}

struct CustomNumberPad: View {
    @Binding var text: String

    let rows: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "Del"]
    ]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(rows, id: \.self) { roww in
                HStack(spacing: 0) {
                    ForEach(roww, id: \.self) { number in
                        Button {
//                            withAnimation {
                                self.handleButtonTap(number)
//                            }
                        } label: {
                            Text(number)
                                .font(.Jamsil.medium.font(size: 24))
                                .frame(width: 50, height: 38)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .cornerRadius(10)
                        }.frame(width: 114, height: 72)
                        
                    }
                }
            }
        }
    }

    func handleButtonTap(_ number: String) {
        if number == "Del" {
            if !text.isEmpty {
                if let index = findLastNumberIndex(in: text) {
                    var arr = Array(text)
                    let indd = abs(index-3)
                    arr[indd] = " "
                    text = String(arr)
                }
                
            }
        } else if text.count <= 4 {
            let originalString = text
            let targetString = " "
            let replacementString = number
            
            if let range = originalString.range(of: targetString) {
                let replacedString =
                originalString.replacingOccurrences(of: targetString, with: replacementString, range: range)
                text = replacedString
            }
        }
    }
    
    func findLastNumberIndex(in text: String) -> Int? {
        let reversedText = String(text.reversed())
        if let index = reversedText.firstIndex(where: { $0.isNumber }) {
            return reversedText.distance(from: reversedText.startIndex, to: index)
        }
        return nil
    }

}

struct CustomTextField: View {
    @Binding var text: String

    var body: some View {
        VStack {
            HStack {
                ForEach(Array(text), id: \.self) { char in
                    DigitView(digit: char)
                }
            }
//            .animation(.default)
            .padding()
        }
    }
}

struct DigitView: View {
    var digit: Character

    var body: some View {
        Text(String(digit))
            .font(.Jamsil.bold.font(size: 30))
            .frame(width: 30, height: 30)
            .foregroundColor(.black)
            .overlay(
                Rectangle()
                    .frame(width: 20, height: 3)
                    .foregroundColor(Color(hexCode: "#D9D9D9"))
                    .offset(y: 20)
            )
    }
}
