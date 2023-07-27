//
//  ImageButton.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/19.
//

import Foundation
import SwiftUI

struct ImageButton: View {
    enum ImageButtonEnum: String {
        case left = "left.png"
        case right = "right.png"
        case checkmark = "checkmark.png"
        case exit = "exit.png"
    }
    
    let image: ImageButtonEnum
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image("\(image)")
        }
    }
}

struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ImageButton(image: .left) { }
            ImageButton(image: .right) { }
            ImageButton(image: .checkmark) { }
            ImageButton(image: .exit) { }
        }
        
    }
}
