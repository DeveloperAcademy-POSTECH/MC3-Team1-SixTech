//
//  MapUI.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/19.
//

import SwiftUI
import MapKit

struct MapUI: UIViewRepresentable {
	@ObservedObject var locationManager: LocationManager

	func makeUIView(context: Context) -> MKMapView {
		locationManager.mapView.showsCompass = false
		return locationManager.mapView
	}
	
	func updateUIView(_ uiView: MKMapView, context: Context) {
		switch locationManager.trackUser {
		case .follow, .followWithHeading:
			uiView.setRegion(locationManager.region, animated: true)
		default:
			break
		}
		updateOverlays(from: uiView)
	}

	private func updateOverlays(from mapView: MKMapView) {
		let locations = locationManager.userLocations
		let polyline = MKPolyline(coordinates: locations, count: locations.count)
		mapView.addOverlay(polyline)
	}
}
