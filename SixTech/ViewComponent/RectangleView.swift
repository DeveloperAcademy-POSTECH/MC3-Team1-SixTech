//
//  RectangleView.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/27.
//

import SwiftUI

struct RectangleView<Content: View>: View {
	let content: Content

	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}

	var body: some View {
		RoundedRectangle(cornerRadius: 20)
			.frame(maxWidth: 320, maxHeight: 160)
			.foregroundColor(.backgroundColor)
//			.opacity(0.2)
//			.shadow(radius: 0, x: 2, y: 2)
			.overlay(content)
			.padding(.top)
			.padding(.horizontal)
	}
}
