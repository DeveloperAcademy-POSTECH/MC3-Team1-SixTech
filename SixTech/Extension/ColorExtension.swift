//
//  ColorExtension.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/13.
//

import Foundation
import SwiftUI

// 폰트는 .font(.custom("TheJamsilOTF3Regular", size: 24))처럼 사용하고, "" 안에 이름은 파일명으로 할 것.
extension Color {
  init(hexCode: String) {
    let scanner = Scanner(string: hexCode)
    _ = scanner.scanString("#")
    
    var rgbColor: UInt64 = 0
    scanner.scanHexInt64(&rgbColor)
    
    let rColor = Double((rgbColor >> 16) & 0xFF) / 255.0
    let gColor = Double((rgbColor >>  8) & 0xFF) / 255.0
    let bColor = Double((rgbColor >>  0) & 0xFF) / 255.0
    self.init(red: rColor, green: gColor, blue: bColor)
  }
}

extension Color {
    static let defaultColor = Color(hexCode: "#28CBAE")
    static let backgroundColor = Color(hexCode: "#B8E3D4")
    static let background2Color = Color(hexCode: "#DBEDE7")
    static let disableColor = Color(hexCode: "#B3B3B3")
    static let buttonBackgroundColor = Color(hexCode: "F5F5F5")
}
