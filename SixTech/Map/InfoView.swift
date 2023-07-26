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
			VStack {
				HStack {
					Spacer()
					Image(systemName: "scope")
						.font(.system(size: 25))
						.foregroundColor(.gray)
						.padding(10)
						.background {
							Circle()
								.foregroundColor(.white)
								.shadow(radius: 0, x: 1, y: 1)
					}
				}
				.padding()

				Spacer()
				
				ActivityDataView()
			}
		}
	}
}

struct ActivityDataView: View {
	
	@State private var pauseTapped = false

	var body: some View {
		ZStack {
			VStack {
				RectangleInfoView {
					VStack {
						Spacer()
						HStack {
							Spacer()
							VStack {
								Text("10.1")
									.font(.system(size: 30))
//									.font(.system(size: 30, weight: .bold, design: .rounded))
								Text("km")
									.font(.system(size: 15))
							}
							Spacer()
							VStack {
								Text("1,010")
									.font(.system(size: 30))
								Text("걸음")
									.font(.system(size: 15))
							}
							Spacer()
							VStack {
								Text("100")
									.font(.system(size: 30))
								Text("줍깅")
									.font(.system(size: 15))
							}
							Spacer()
						}
						Spacer()
						if pauseTapped {
							Text("00:46:57")
								.font(.system(size: 40))
							.bold()
							Text("경과 시간")
								.font(.system(size: 12))
								.padding(.bottom)
							Spacer()
						}
					}
				}
				.frame(height: pauseTapped ? 160 : 80)
				if pauseTapped {
					RectangleInfoView {
						VStack {
							Text("나의 같이줍깅 미션")
								.font(.system(size: 16))
								.padding(.top)
							Spacer()
							RoundedRectangle(cornerRadius: 10)
								.frame(maxWidth: 270, maxHeight: 40)
								.foregroundColor(.white)
								.padding(.horizontal)
								.padding(.horizontal)
								.overlay {
									Text("길가에 핀 꽃 사진찍기")
										.font(.system(size: 16))
								}
							Spacer()
							RoundedRectangle(cornerRadius: 35)
								.frame(maxWidth: 270, maxHeight: 50)
								.foregroundColor(.green)
								.padding(.horizontal)
								.padding(.horizontal)
								.overlay {
									HStack {
										Image(systemName: "camera.fill")
										Text("미션 하러 가기")
											.bold()
									}
									.foregroundColor(.white)
								}
							Spacer()
						}
					}
				}
				
				if pauseTapped {
					HStack {
						ControlButtonView(buttonType: .stop) {
							
						}
						.padding()
						ControlButtonView(buttonType: .play) {
							self.pauseTapped = false
						}
						.padding()
					}
				} else {
					ControlButtonView(buttonType: .pause) {
						self.pauseTapped = true
					}
					.padding()
				}
			}
		}
		.background {
			RoundedRectangle(cornerRadius: 40)
				.foregroundColor(.white)
		}
	}
}

private struct RectangleInfoView<Content: View>: View {
	let content: Content

	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}

	var body: some View {
		RoundedRectangle(cornerRadius: 20)
			.frame(maxWidth: 320, maxHeight: 160)
			.foregroundColor(.green)
			.opacity(0.2)
			.shadow(radius: 0, x: 2, y: 2)
			.overlay(content)
			.padding(.top)
			.padding(.horizontal)
	}
}

private struct ControlButtonView: View {
	var buttonType: ControlButtonType
	var buttonAction: () -> Void

	var body: some View {
		Button(action: buttonAction) {
			Image(systemName: buttonType.systemName)
				.font(.system(size: 30))
				.bold()
				.shadow(radius: 0, x: 1, y: 1)
				.foregroundColor(.red)
				.padding()
				.background {
					Circle()
						.foregroundColor(.white)
						.shadow(radius: 0, x: 1, y: 1)
				}
		}
	}
}

private enum ControlButtonType {
	case stop, play, pause

	var systemName: String {
		switch self {
		case .stop:
			return "stop.fill"
		case .play:
			return "play.fill"
		case .pause:
			return "pause.fill"
		}
	}
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
