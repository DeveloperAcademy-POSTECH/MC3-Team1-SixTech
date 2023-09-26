//
//  CharacterCreateView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/18.
//

import SwiftUI

struct CharacterCreateView: View {
    @AppStorage("onboarding") var isOnboardingActive: Bool = true
    @EnvironmentObject var userInfo: UserInfo
    
    @StateObject private var viewModel = CharacterCreateViewModel()
    @State private var isButtonTap = false
    @State private var isButtonDisabled = true
    
    var body: some View {
        VStack {
            Spacer()
            Text("캐릭터를 생성해주세요.")
                .font(.Jamsil.bold.font(size: 20))
                .padding(.vertical)
                .padding(.top)
            Text("같이줍깅을 하려면 캐릭터가 필요해요.")
                .font(.Jamsil.light.font(size: 17))
            HStack {
                VStack {
                    ImageButton(image: .left) { viewModel.decreaseCount(kind: .face) }
                        .padding(.bottom)
                    ImageButton(image: .left) { viewModel.decreaseCount(kind: .emotion) }
                        .padding(.bottom)
                    ImageButton(image: .left) { viewModel.decreaseCount(kind: .color) }
                        .padding(.bottom)
                }
                
                Image(uiImage: viewModel.imageMerger.merge("\(viewModel.faceArray[viewModel.characterFace] + viewModel.colorArray[viewModel.characterColor])", with: "\(viewModel.emotionArray[viewModel.characterEmotion])"))
                    .resizable()
                    .frame(width: 200, height: 200)
                VStack {
                    ImageButton(image: .right) { viewModel.increaseCount(kind: .face) }
                        .padding(.bottom)
                    ImageButton(image: .right) { viewModel.increaseCount(kind: .emotion) }
                        .padding(.bottom)
                    ImageButton(image: .right) { viewModel.increaseCount(kind: .color) }
                        .padding(.bottom)
                }
            }
            
            TextField("닉네임을 입력해주세요", text: $viewModel.userName)
                .font(.Jamsil.light.font(size: 17))
                .multilineTextAlignment(.center)
                .frame(width: 330, height: 70)
                .overlay {
                    RoundedRectangle(cornerRadius: 23)
                        .stroke(Color.defaultColor, lineWidth: 2)
                }
                .onChange(of: viewModel.userName) { newValue in
                    if (!newValue.isEmpty && newValue.count < 6) {
                        isButtonDisabled = false
                        print(newValue.count)
                    } else {
                        isButtonDisabled = true
                    }
                }
            HStack {
                Image(systemName: "questionmark.circle")
                    .foregroundColor(.gray)
                    .padding(.leading)
                    .padding(.leading)
                Text("최대 6글자 이내, 특수문자 사용 불가")
                    .foregroundColor(.gray)
                    .font(.Jamsil.light.font(size: 12))
                Spacer()
            }

            Spacer()
            Spacer()
            NavigationLinkView(text: "선택하기", isdisable: $isButtonDisabled, destination: MainView())
            .simultaneousGesture(TapGesture().onEnded {
                isOnboardingActive = false
                viewModel.saveUserDefault()
                userInfo.profileImage = [ viewModel.characterFace,
                                          viewModel.characterColor,
                                          viewModel.characterEmotion
                ]
                UserDefaults.standard.set([ viewModel.characterFace,
                                            viewModel.characterColor,
                                            viewModel.characterEmotion
                                          ], forKey: "profileArr")
            })
        }
        .navigationBarBackButtonHidden()
    }
}

struct CharacterChangeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userInfo: UserInfo
    
    @StateObject private var viewModel = CharacterCreateViewModel()
    @State private var isButtonTap = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("캐릭터를 생성해주세요.")
                .font(.Jamsil.bold.font(size: 20))
            Text("같이줍깅을 하려면 캐릭터가 필요해요")
                .font(.Jamsil.light.font(size: 17))
            HStack {
                VStack {
                    ImageButton(image: .left) { viewModel.decreaseCount(kind: .face) }
                    ImageButton(image: .left) { viewModel.decreaseCount(kind: .emotion) }
                    ImageButton(image: .left) { viewModel.decreaseCount(kind: .color) }
                }
                
                Image(uiImage: viewModel.imageMerger.merge("\(viewModel.faceArray[viewModel.characterFace] + viewModel.colorArray[viewModel.characterColor])", with: "\(viewModel.emotionArray[viewModel.characterEmotion])"))
                    .resizable()
                    .frame(width: 200, height: 200)
                
                VStack {
                    ImageButton(image: .right) { viewModel.increaseCount(kind: .face) }
                    ImageButton(image: .right) { viewModel.increaseCount(kind: .emotion) }
                    ImageButton(image: .right) { viewModel.increaseCount(kind: .color) }
                }
            }
            
            TextField("닉네임을 입력해주세요", text: $viewModel.userName)
                .font(.Jamsil.light.font(size: 17))
                .multilineTextAlignment(.center)
                .frame(width: 330, height: 70)
                .overlay {
                    RoundedRectangle(cornerRadius: 23)
                        .stroke(Color.defaultColor, lineWidth: 2)
                }

            Spacer()
            Spacer()
                            
            ButtonView(text: "선택하기", isdisable: Binding.constant(false), action: {
                dismiss()
            })
            .simultaneousGesture(TapGesture().onEnded {
                viewModel.saveUserDefault()
                userInfo.profileImage = [ viewModel.characterFace,
                                          viewModel.characterColor,
                                          viewModel.characterEmotion
                ]
                UserDefaults.standard.set([ viewModel.characterFace,
                                            viewModel.characterColor,
                                            viewModel.characterEmotion
                                          ], forKey: "profileArr")
            })
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                dismissButton(sfName: "chevron.backward") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("내 프로필")
                    .font(.Jamsil.bold.font(size: 20))
            }
            
        }
        .navigationBarBackButtonHidden()
    }
}

struct CharacterCreateView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterChangeView()
    }
}
