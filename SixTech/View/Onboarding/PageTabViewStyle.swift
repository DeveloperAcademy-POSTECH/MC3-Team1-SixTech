//
//  PageTabViewStyle.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/13.
//

import SwiftUI

struct PageTabViewStyle: View {
    let circleSize: CGFloat = 15
    let pageNumber: Int
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: circleSize, height: circleSize)
                .foregroundColor(pageNumber==1 ? .defaultColor : .backgroundColor)
            Circle()
                .frame(width: circleSize, height: circleSize)
                .foregroundColor(pageNumber==2 ? .defaultColor : .backgroundColor)
            Circle()
                .frame(width: circleSize, height: circleSize)
                .foregroundColor(pageNumber==3 ? .defaultColor : .backgroundColor)
        }
        .padding()
    }
}

struct PageTabViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        PageTabViewStyle(pageNumber: 1)
    }
}
