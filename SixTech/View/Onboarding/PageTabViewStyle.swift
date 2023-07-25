//
//  PageTabViewStyle.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/13.
//

import SwiftUI

struct PageTabViewStyle: View {
    let circleSize: CGFloat = 8
    let pageNumber: Int
    let totalPageNumber: Int
    
    var body: some View {
        HStack {
            ForEach(1...totalPageNumber, id: \.self) { index in
                Circle()
                    .frame(width: circleSize, height: circleSize)
                    .foregroundColor(pageNumber == index ? .defaultColor : .backgroundColor)
            }
        }
        .padding()
    }
}

struct PageTabViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        PageTabViewStyle(pageNumber: 1, totalPageNumber: 3)
    }
}
