//
//  CreateRoom.swift
//  SixTech
//
//  Created by 주환 on 2023/07/19.
//

import SwiftUI

struct CreateRoomView: View {
    @EnvironmentObject var matchManager: MatchManager
    @Environment(\.dismiss) var dismiss
    
    @State private var selection = 0
    @State private var isPickerView = false
    @State private var isDisable = true
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("인원 수")
                    .font(.Jamsil.bold.font(size: 20))
                
                Picker("", selection: $selection) {
                    Text("\(selection)")
                        .font(.Jamsil.bold.font(size: 20))
                        .foregroundColor(.defaultColor)
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
            } // MARK: 인원수 뷰 스택
            .padding([.leading, .trailing])
            .padding(.top)
            
            if isPickerView {
                HStack {
                    Picker("", selection: $selection) {
                        ForEach(0...10, id: \.self) { number in
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
            } // MARK: 피커뷰 on/off 스택
            Divider()
                .padding(.bottom)
            HStack {
                Text("참여 코드")
                    .font(.Jamsil.bold.font(size: 20))
                    .padding(.leading)
                Spacer()
            } // MARK: 참여코드 헤드라인 뷰 스택
            HStack {
                Spacer()
                Text(matchManager.groupNumber.isEmpty ? "0000": matchManager.groupNumber)
                    .font(.Jamsil.bold.font(size: 34))
                    .foregroundColor(.defaultColor)
                Spacer()
//                Image(systemName: "doc.on.doc.fill")
//                    .foregroundColor(.defaultColor)
//                    .padding(.trailing)
            } // MARK: 참여코드 복사 뷰 스택
            .frame(width: 342, height: 76)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.init(hexCode: "#F5F5F5"))
					.overlay(alignment: .trailing, content: {
						Spacer()
						Image(systemName: "doc.on.doc.fill")
							.foregroundColor(.defaultColor)
							.padding(.trailing)
					})
            )
            
            HStack {
                Image(systemName: "questionmark.circle")
					.foregroundColor(.gray)
                Text("다른 팀원들은 참여코드가 있어야 입장할 수 있어요.")
                    .font(.Jamsil.light.font(size: 14))
					.foregroundColor(.gray)
            }// MARK: 팁스택
            
            Spacer()
            Spacer()
            NavigationLinkView(text: "방 만들기", isdisable: $isDisable, destination: WaitingRoomView())
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                dismissButton(sfName: "chevron.backward") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("방 만들기")
                    .font(.Jamsil.bold.font(size: 24))
            }
        } // MARK: 네비게이션 바뷰
        
        .onAppear {
            matchManager.generateRandomPlayCode()
        }
        .onChange(of: selection, perform: { newValue in
            if newValue > 0 {
                isDisable = false
            } else {
                isDisable = true
            }
            matchManager.maxPlayer = newValue
        })
        .navigationBarBackButtonHidden()
    }
}

struct CreateRoomView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoomView()
            .environmentObject(MatchManager())
    }
}
