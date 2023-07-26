//
//  FontExtension.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/15.
//

import Foundation
import SwiftUI

extension Font {
    enum Jamsil: String {
        case thin = "TheJamsilOTF1Thin"
        case light = "TheJamsilOTF2Light"
        case regular = "TheJamsilOTF3Regular"
        case medium = "TheJamsilOTF4Medium"
        case bold = "TheJamsilOTF5Bold"
        case extraBold = "TheJamsilOTF6ExtraBold"
        
        func font(size: CGFloat) -> Font {
            return Font.custom(rawValue, size: size)
        }
    }
}

struct Font_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("폰트이름을 알아보자")
        }.onAppear {
            print("----------------------------------------------------")
            for family in UIFont.familyNames.sorted() {
                let names = UIFont.fontNames(forFamilyName: family)
                print("Font names: \(names)")
            }
        }
        
    }
}
