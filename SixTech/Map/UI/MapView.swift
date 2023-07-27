//
//  MapView.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/13.
//

import SwiftUI
import MapKit

struct MapView: View {
	@ObservedObject var locationManager = LocationManager()
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
					
					Button {
						SnapshotManager.takeSnapshot(mapView: locationManager.mapView,
													 polyline: locationManager.polylines) { image in
							if let image = image {
								snapshottedMap = image
							} else { return }
						}
					} label: {
						Text("Snapshot")
					}
					NavigationLink(destination: TestPhotoView(snapshot: $snapshottedMap)) {
						Text("gotosnapshot")
					}
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
