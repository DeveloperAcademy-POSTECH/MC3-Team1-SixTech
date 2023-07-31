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
					ActivityDataView()
						.padding(.bottom)
						.padding(.bottom)
				}
			}
		}
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
