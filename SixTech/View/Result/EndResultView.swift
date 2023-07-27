//
//  EndResultView.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/26.
//

import SwiftUI

struct EndResultView: View {
    @Environment(\.presentationMode) var prsent
    
    @State var userImage: String = "ploggingphoto"
    @State var mapImage: String = "usermap"
    
    @State var isRightTapped: Bool = false
    @State var isLeftTapped: Bool = true
    @State var isAlert = false
    
    var body: some View {
        
        HStack {
            VStack {
                HStack {
                    
                    Spacer()
                    
                    Button {
                        isAlert = true
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .background(Color.buttonBackgroundColor)
                            .foregroundColor(Color.defaultColor)
                            .clipShape(Circle())
                    }
                }
                
                Text("오늘의 플로깅 기록")
                    .font(.Jamsil.bold.font(size: 20))
                    .padding(.bottom, 8)
                
                Text("플로깅 완료를 축하합니다!\n 마음에 드는 기록을 공유/저장해요")
                    .font(.Jamsil.light.font(size: 17))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                if isLeftTapped {
                    ResultWithPhotoView()
                        .padding(.vertical)
                } else {
                    ResultWithPolylineView()
                        .padding(.vertical)
                }
                
                Spacer()
                
                HStack {
                    Button {
                        isLeftTapped = true
                        isRightTapped = false
                    } label: {
                        Image(userImage)
                            .resizable()
                            .scaledToFill()
                    }
                    .buttonStyle(CircleButton(isTapped: $isLeftTapped))
                    
                    Spacer()
                    
                    Button {
                        isRightTapped = true
                        isLeftTapped = false
                    } label: {
                        
                        Image(mapImage)
                            .resizable()
                            .scaledToFill()
                    }
                    .buttonStyle(CircleButton(isTapped: $isRightTapped))
                    
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                Spacer()
                
                HStack {
                    Button {
                        // 저장하는 기능
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                                .padding(.trailing)
                            
                            Text("저장하기")
                                .padding(.trailing)
                        }
                    }
                    .buttonStyle(SmallButton())
                    
                    Spacer()
                    
                    Button {
                        // 공유하는 기능
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                                .padding(.trailing)
                            
                            Text("공유하기")
                                .padding(.trailing)
                        }
                    }
                    .buttonStyle(SmallButton())
                }
                Spacer()
            }
            .padding(.top, 47)
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.horizontal, 24)
        .alert(title: "플로깅 완료",
               message:
                            """
                            메인화면으로 돌아갑니다.
                            내 프로필에서 기륵을
                            확인할 수 있어요
                            """,
               primaryButton: CustomAlertButton(title: "확인", action: { NavigationUtil.popToRootView() }),
               secondaryButton: CustomAlertButton(title: "취소", action: { isAlert = false }),
               isPresented: $isAlert)
        .navigationBarBackButtonHidden()
    }
    
}

struct EndResultView_Previews: PreviewProvider {
    static var previews: some View {
        EndResultView()
    }
}
