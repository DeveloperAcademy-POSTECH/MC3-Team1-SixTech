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
        case thin = "TheJamsilOTF1Thin.otf"
        case light = "TheJamsilOTF2Light.otf"
        case regular = "TheJamsilOTF3Regular.otf"
        case medium = "TheJamsilOTF4Medium.otf"
        case bold = "TheJamsilOTF5Bold.otf"
        case extraBold = "TheJamsilOTF6ExtraBold.otf"
        
        func font(size: CGFloat) -> Font {
            return Font.custom(rawValue, size: size)
        }
    }
}
