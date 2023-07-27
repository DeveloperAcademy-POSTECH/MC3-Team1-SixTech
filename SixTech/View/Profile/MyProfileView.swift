//
//  MyProfileView.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/26.
//

import SwiftUI

struct MyProfileView: View {
    var body: some View {
        HStack {
            
            VStack {
                
                HStack {
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .background(Color.buttonBackgroundColor)
                            .foregroundColor(Color.defaultColor)
                            .clipShape(Circle())
                        
                    }
                    
                    Spacer()
                    
                }
                
                Spacer()
                
            }
            .padding(.top ,47)
            
            
            
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.horizontal, 24)
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}
