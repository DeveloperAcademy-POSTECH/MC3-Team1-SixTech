//
//  LocationManager.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/13.
//
//	c5 좌표값 (latitude: 36.0141, longitude: 129.3259)
//

import MapKit
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, MKMapViewDelegate {
	var locationManager: CLLocationManager?
	var userLocations = [[CLLocationCoordinate2D]]()
	var isStop = false

	@Published var mapView: MKMapView = MKMapView()
	@Published var trackUser: UserTrackingMode = .follow
	@Published var region = MKCoordinateRegion()
	@Published var movedDistance: Double = 0.0
	@Published var polylines: MKMultiPolyline = MKMultiPolyline()

	override init() {
		super.init()
		setupLocationManager()
		updateRegion()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }

		if let lastLocation = userLocations.last?.last, !isStop {
			let distance = location.distance(from: CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude))
			self.movedDistance += distance
		}

		if userLocations.isEmpty {
			userLocations.append([location.coordinate])
		} else {
			userLocations[userLocations.count - 1].append(location.coordinate)
		}
		
		let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
											longitude: location.coordinate.longitude)
		let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
		region = MKCoordinateRegion(center: center, span: span)
		
		updatePolyline()
	}
	
	func drawPolyline() {
		let overlays = mapView.overlays
		mapView.removeOverlays(overlays)
		addPolylineToMap()
	}
	
	private func updatePolyline() {
		let polylines = userLocations.map { MKPolyline(coordinates: $0, count: $0.count) }
		self.polylines = MKMultiPolyline(polylines)
	}
	
	private func addPolylineToMap() {
		let polyline = MKMultiPolyline(userLocations.map { MKPolyline(coordinates: $0, count: $0.count) })
		mapView.addOverlay(polyline)
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if let imageAnnotation = annotation as? ImageAnnotation {
			var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ImageAnnotationView.identifier)
			
			if annotationView == nil {
				annotationView = ImageAnnotationView(annotation: imageAnnotation,
													  reuseIdentifier: ImageAnnotationView.identifier)
			} else {
				annotationView?.annotation = imageAnnotation
			}
			
			return annotationView
		}
		return nil
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkLocationAuthorization()
	}
	
	func startUpdating() {
		locationManager?.startUpdatingLocation()
		isStop = false
	}
	
	func stopUpdating() {
//		locationManager?.stopUpdatingLocation()
		isStop = true
	}
	
	func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
		let view = mapView.subviews.first
		if view?.gestureRecognizers?.contains(where: { $0.state == .began || $0.state == .changed }) == true {
			DispatchQueue.main.async {
				self.trackUser = .none
				self.updateTrackingMode()
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let multiPolyline = overlay as? MKMultiPolyline {
			let renderer = MKMultiPolylineRenderer(multiPolyline: multiPolyline)
			renderer.strokeColor = UIColor(red: 40/255, green: 203/255, blue: 174/255, alpha: 1)
			renderer.lineWidth = 5
			return renderer
		}
		return MKOverlayRenderer()
	}
	
	private func setupLocationManager() {
		self.locationManager = CLLocationManager()
		self.locationManager!.delegate = self
		self.locationManager!.distanceFilter = 10.0
		self.locationManager!.requestWhenInUseAuthorization()
		self.locationManager!.startUpdatingLocation()

		self.mapView.delegate = self
		self.mapView.showsUserLocation = true
		self.mapView.userTrackingMode = .none
	}
	
	private func updateRegion() {
		guard let location = locationManager?.location else { return }
		let span = mapView.region.span
		region = MKCoordinateRegion(center: location.coordinate,
									span: span)
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
	
	func changeTrackingMode() {
		switch trackUser {
		case .none:
			trackUser = .follow
		case .follow:
			trackUser = .followWithHeading
		case .followWithHeading:
			trackUser = .none
		}
		updateTrackingMode()
	}
	
	private func updateTrackingMode() {
		switch trackUser {
		case .none:
			mapView.userTrackingMode = .none
		case .follow:
			mapView.userTrackingMode = .follow
		case .followWithHeading:
			mapView.userTrackingMode = .followWithHeading
		}
	}
	
	func addPolaroidAnnotation() {
		if let image = UIImage(named: "testImage") {
			let newImage = drawPolaroidOnImage(image: image)
			let imageAnnotation = ImageAnnotation(image: newImage, coordinate: locationManager!.location!.coordinate)
			mapView.addAnnotation(imageAnnotation)
		}
	}
	
	func drawPolaroidOnImage(image: UIImage) -> UIImage {
		let imageSize = image.size
		let padding: CGFloat = 10
		let totalSize = CGSize(width: imageSize.width + 2 * padding, height: imageSize.height + 2 * padding + 30)
		let renderer = UIGraphicsImageRenderer(size: totalSize)
		
		let newImage = renderer.image { context in
			let rectangleColor = UIColor.white
			let rectangleRect = CGRect(x: 0, y: 0, width: totalSize.width, height: totalSize.height)
			
			context.cgContext.setFillColor(rectangleColor.cgColor)
			context.cgContext.setStrokeColor(rectangleColor.cgColor)
			context.cgContext.setLineWidth(10)
			context.cgContext.addRect(rectangleRect)
			context.cgContext.drawPath(using: .fillStroke)
			
			image.draw(at: CGPoint(x: padding, y: padding))
		}
		
		return newImage
	}
}

enum UserTrackingMode {
	case none
	case follow
	case followWithHeading
}
