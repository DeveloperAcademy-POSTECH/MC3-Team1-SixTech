//
//  ContentView.swift
//  SixTech
//
//  Created by 이재원 on 2023/07/09.
//

import SwiftUI

struct ContentView: View {
	
	let num65: Int = 3
	
	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)
			Text("Hello, world!")
		}
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
