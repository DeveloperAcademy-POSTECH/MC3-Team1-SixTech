//
//  DeveloperInfoView.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/27.
//

import SwiftUI

struct DeveloperInfoView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        ScrollView {
            VStack {
                ZStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            // 버튼 배경색이 아직 안들어와있어서 회색으로 대체...
                            Image(systemName: "chevron.backward")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.defaultColor)
                                .padding()
                                .background(Color.buttonBackgroundColor)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    Text("같이줍깅을 만든 사람들")
                        .font(.Jamsil.medium.font(size: 20))
                }
                .padding(.bottom)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .foregroundColor(.background2Color)
                    
                    VStack {
                        HStack {
                            Rectangle()
                                .frame(width: 50, height: 1)
                            
                            Text("우당탕탕 식스텍")
                                .font(.Jamsil.thin.font(size: 15))
                            
                            Rectangle()
                                .frame(width: 50, height: 1)
                        }
                        .padding()
                        
                        LeftImageIntroduceView(imagename: "jeckmu", developer: "젝무", title: "거북이 - 가디")
                        
                        RightImageIntroduceView(imagename: "musk", developer: "머스크", title: "머식머식")
                        
                        LeftImageIntroduceView(imagename: "madeline", developer: "매들린", title: "디자인해")
                        
                        RightImageIntroduceView(imagename: "jerry", developer: "제리", title: "코코집사")
                        
                        LeftImageIntroduceView(imagename: "junyoo", developer: "준유", title: "문구를\n입력해주세요")
                        
                        RightImageIntroduceView(imagename: "lorenzo", developer: "로렌조", title: "이 뷰 만든이")
                    }
                    .padding(.bottom)
                }
            }
            .padding(.horizontal, 24)
        }
        
        .navigationBarBackButtonHidden()
    }
}

struct DeveloperInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperInfoView()
    }
}
