//
//  ViewExtension.swift
//  SixTech
//
//  Created by 주환 on 2023/07/27.
//

import SwiftUI

extension View {
    func alert(title: String = "", message: String = "",
               primaryButton: CustomAlertButton, secondaryButton: CustomAlertButton,
               isPresented: Binding<Bool>) -> some View {
        let title   = NSLocalizedString(title, comment: "")
        let message = NSLocalizedString(message, comment: "")
    
        return modifier(CustomAlertModifier(title: title, message: message, primaryButton: primaryButton,
                                            secondaryButton: secondaryButton, isPresented: isPresented))
    }
}
