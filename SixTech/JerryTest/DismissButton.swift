//
//  File.swift
//  SixTech
//
//  Created by 주환 on 2023/07/20.
//

import SwiftUI

func dismissButton(completion: @escaping() -> Void) -> some View {
        Button {
            completion()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.defaultColor)
                .fontWeight(.heavy)
                .background(
                    Circle()
                        .fill(Color.init(hexCode: "#F5F5F5"))
                        .frame(width: 45, height: 45)
                )
        }
}
