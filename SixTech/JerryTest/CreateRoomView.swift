//
//  CreateRoom.swift
//  SixTech
//
//  Created by 주환 on 2023/07/19.
//

import SwiftUI

struct CreateRoomView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var selection = 1
    
    @State private var isPickerView = true
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("인원 수")
                        .font(.Jamsil.bold.font(size: 20))
                    
                    Picker("", selection: $selection) {
                            Text("\(selection)")
                                .font(.Jamsil.bold.font(size: 20))
                                .foregroundColor(.defaultColor)
                                .padding(.trailing)
                    }
                    .frame(height: 40)
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .onTapGesture {
                        withAnimation {
                            isPickerView.toggle()
                        }
                    }
                    
                    Text("명")
                        .font(.Jamsil.bold.font(size: 20))
                } // 인원수 뷰 스택
                .padding([.leading, .trailing])
                
                if isPickerView {
                    HStack {
                        Picker("", selection: $selection) {
                            ForEach(1...10, id: \.self) { number in
                                Text("\(number)").tag(number)
                                    .font(.Jamsil.bold.font(size: 23))
                                    .foregroundColor(.defaultColor)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .labelsHidden()
                        .frame(height: 100)
                        .background(Color.white)
                    }
                } else {
                    Spacer().frame(height: 100)
                } // 피커뷰 on/off 스택
                Divider()
                HStack {
                    Text("참여 코드")
                        .font(.Jamsil.bold.font(size: 20))
                        .padding(.leading)
                    Spacer()
                } // 참여코드 헤드라인 뷰 스택
                
                HStack {
                    Spacer()
                    Text("0000")
                        .font(.Jamsil.bold.font(size: 34))
                        .foregroundColor(.defaultColor)
                    Spacer()
                    Image(systemName: "doc.on.doc.fill")
                        .foregroundColor(.defaultColor)
                        .padding(.trailing)
                } // 참여코드 복사 뷰 스택
                .frame(width: 342, height: 76)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.init(hexCode: "#F5F5F5"))
                )
                
                HStack {
                    Image(systemName: "questionmark.circle")
                    Text("다른 팀원들은 참여코드가 있어야 입장할 수 있어요.")
                        .font(.Jamsil.light.font(size: 14))
                }// 팁스택
                
                Spacer()
                
                NavigationLink("방 만들기") {
                }.buttonStyle(DefaultButton(isdisable: false)) // 버튼 뷰
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    dismissButton {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("방 만들기")
                        .font(.Jamsil.bold.font(size: 30))
                }
            }
        }
    }
}

struct CreateRoomView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoomView()
    }
}
