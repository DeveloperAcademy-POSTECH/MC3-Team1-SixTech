//
//  InfoView.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/24.
//

import SwiftUI

struct InfoView: View {
	var body: some View {
		ZStack {
			Color.gray.ignoresSafeArea()
			VStack{
				Spacer()
				
				Capsule()
					.foregroundColor(.green)
					.frame(width: UIScreen.main.bounds.width * 0.9,
						   height: 83)
					.overlay{
						HStack {
							Spacer()
							Circle()
								.frame(width: 55)
								.foregroundColor(.white)
								.overlay {
									Circle()
										.foregroundColor(.indigo)
										.padding()
								}
								.offset(x: 10)
							Spacer()
							CapsuleView()
							Spacer()
							Circle()
								.frame(width: 55)
								.foregroundColor(.white)
								.overlay {
									Image(systemName: "stop.fill")
										.font(.system(size: 30))
										.foregroundColor(.red)
								}
								.offset(x: -10)
							Spacer()
							
						}
					}
				Spacer()
				
				Image(systemName: "location.fill")
					.frame(width: .zero, height: .zero)
					.padding()
					.background(Color.white)
					.clipShape(Circle())
					.shadow(radius: 0, x: 1, y: 1)
					.overlay(Circle().stroke(lineWidth: 0.05))
				//				.opacity(0.75)
				Spacer()
			}
		}
	}
}

struct CapsuleView: View {
	var body: some View {
		VStack {
			Image(systemName: "figure.walk")
				.font(.system(size: 40))
				.frame(width: 65, height: 40)
				.foregroundColor(.white)
				.overlay {
					Text("10.8")
						.font(.title2)
						.bold()
				}
			Text("개수")
				.font(.caption)
		}
		Spacer()
		
		VStack {
			Image(systemName: "shoeprints.fill")
				.font(.system(size: 40))
				.frame(width: 65, height: 40)
				.foregroundColor(.white)
				.overlay {
					Text("9994")
						.font(.system(size: 25))
						.bold()
				}
			Text("걸음")
				.font(.caption)
		}
		Spacer()
		
		VStack {
			Image(systemName: "trash.fill")
				.frame(width: 65, height: 40)
				.font(.system(size: 40))
				.foregroundColor(.white)
				.overlay {
					Text("200")
						.font(.title2)
						.bold()
				}
			Text("줍깅")
				.font(.caption)
		}
	}
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
