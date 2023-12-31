//
//  MapView.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/13.
//

import SwiftUI
import MapKit

struct MapView: View {
	@EnvironmentObject var locationManager: LocationManager
	@EnvironmentObject var ploggingManager: PloggingManager
	@State private var snapshottedMap = UIImage()
	@State private var isAlert = false
	@State private var isNextView = false

	var body: some View {
		NavigationView {
			ZStack {
				MapUI(locationManager: locationManager)
					.ignoresSafeArea()
				VStack {
					HStack {
						Spacer()
						Button {
							locationManager.changeTrackingMode()
						} label: {
							Image(systemName: locationIcon(mode: locationManager.trackUser))
								.frame(width: .zero, height: .zero)
								.padding()
								.background(Color.white)
								.clipShape(Circle())
								.shadow(radius: 0, x: 1, y: 1)
						}
						.padding()
					}
					Spacer()
					ActivityDataView(isAlert: $isAlert)
						.padding(.bottom)
						.padding(.bottom)
					NavigationLink("", isActive: $isNextView) {
						ImagePickView()
					}
					.navigationBarBackButtonHidden()
				}
			}
		}
		.navigationBarBackButtonHidden()
		.alert(title: "플로깅 완료", message: "플로깅을 끝내시겠어요?",
			   primaryButton: CustomAlertButton(title: "완료",
												action: { isNextView = true
			isAlert = false
		}),
			   secondaryButton: CustomAlertButton(title: "취소",
												  action: { isAlert = false }),
			   isPresented: $isAlert)
	}
	
	private func locationIcon(mode: UserTrackingMode) -> String {
		switch mode {
		case .none:
			return "location"
		case .follow:
			return "location.fill"
		case .followWithHeading:
			return "location.north.line.fill"
		}
	}
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView()
	}
}
