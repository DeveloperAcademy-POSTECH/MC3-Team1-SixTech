//
//  LocationManager.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/13.
//

import SwiftUI
import MapKit

class LocationManager: ObservableObject {
	private var location: CLLocationCoordinate2D
	private var span: MKCoordinateSpan
	@Published var region: MKCoordinateRegion

	init() {
		self.location = CLLocationCoordinate2D(latitude: 36.0141, longitude: 129.3259)
		self.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
		self.region = MKCoordinateRegion(center: location, span: span)
	}
}
