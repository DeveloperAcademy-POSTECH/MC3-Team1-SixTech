//
//  LocationManager.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/13.
//

import SwiftUI
import MapKit
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
	var locationManager: CLLocationManager?
	
//	@Published var region = MKCoordinateRegion(
//		center: CLLocationCoordinate2D(latitude: 36.0141, longitude: 129.3259),
//		span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//	)
	@Published var region = MKCoordinateRegion()
	@Published var trackUser: Bool = true

	override init() {
		super.init()
		setupLocationManager()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		
		let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
											longitude: location.coordinate.longitude)
		let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
		region = MKCoordinateRegion(center: center, span: span)
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkLocationAuthorization()
	}
	
	func startUpdating() {
		locationManager?.startUpdatingLocation()
	}
	
	func stopUpdating() {
		locationManager?.stopUpdatingLocation()
	}

	private func updateRegion() {
		guard let location = locationManager?.location else { return }
		region = MKCoordinateRegion(center: location.coordinate,
									span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
	}
	
	private func setupLocationManager() {
		self.locationManager = CLLocationManager()
		self.locationManager!.delegate = self
		self.locationManager!.requestWhenInUseAuthorization()
		self.locationManager!.startUpdatingLocation()
	}
	
	private func checkLocationAuthorization() {
		guard let locationManager = locationManager else { return }
		
		switch locationManager.authorizationStatus {
		case .notDetermined:
			break
		case .restricted:
			print("location restricted.")
		case .denied:
			print("location denied.")
		case .authorizedAlways, .authorizedWhenInUse:
			updateRegion()
		@unknown default:
			break
		}
	}
}
