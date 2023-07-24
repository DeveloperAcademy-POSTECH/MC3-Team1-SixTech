//
//  LocationManager.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/13.
//
//	c5 좌표값 (latitude: 36.0141, longitude: 129.3259)
//경로찍기

import MapKit
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, MKMapViewDelegate {
	var locationManager: CLLocationManager?
	
	@Published var mapView: MKMapView = MKMapView()
	@Published var trackUser: UserTrackingMode = .follow
	@Published var userLocations = [CLLocationCoordinate2D]()
	@Published var region = MKCoordinateRegion()

	override init() {
		super.init()
		setupLocationManager()
		updateRegion()
	}
	
	func drawPolyline(polyline: MKPolyline) -> UIImage? {
		let points = polyline.points()
		let coordinates = (0..<polyline.pointCount).map { (index) -> CLLocationCoordinate2D in
			return points[index].coordinate
		}
		
		// 2. 그릴 이미지의 크기를 결정합니다.
		let imageSize = CGSize(width: 500, height: 500)
		
		// 3. UIGraphicsImageRenderer를 이용하여 이미지를 그립니다.
		let renderer = UIGraphicsImageRenderer(size: imageSize)
		let image = renderer.image { context in
			UIColor.clear.setFill()
			context.fill(CGRect(origin: .zero, size: imageSize))
			
			// 4. CGMutablePath를 생성하고 Polyline의 좌표를 추가합니다.
			let path = CGMutablePath()
			if let firstCoordinate = coordinates.first {
				path.move(to: CGPoint(x: firstCoordinate.latitude, y: firstCoordinate.longitude))
			}
			for coordinate in coordinates {
				path.addLine(to: CGPoint(x: coordinate.latitude, y: coordinate.longitude))
			}
			
			// 5. path를 이용하여 선을 그립니다.
			context.cgContext.addPath(path)
			context.cgContext.setStrokeColor(UIColor.red.cgColor)
			context.cgContext.setLineWidth(2.0)
			context.cgContext.strokePath()
		}
		
		return image
	}
		
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		userLocations.append(location.coordinate)
		let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
											longitude: location.coordinate.longitude)
		let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
		region = MKCoordinateRegion(center: center, span: span)
		
//		print(trackUser)
//		print("lat = \(location.coordinate.latitude)")
//		print("lng = \(location.coordinate.longitude)")
	}
	
	func addCustomAnnotation() {
		if let image = UIImage(named: "testImage") {
			let newImage = drawRectangleOnImage(image: image)
			let customAnnotation = CustomAnnotation(image: newImage, coordinate: locationManager!.location!.coordinate)
			mapView.addAnnotation(customAnnotation)
		}
	}
	
	func drawRectangleOnImage(image: UIImage) -> UIImage {
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
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if let customAnnotation = annotation as? CustomAnnotation {
			var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
			
			if annotationView == nil {
				annotationView = CustomAnnotationView(annotation: customAnnotation,
													  reuseIdentifier: CustomAnnotationView.identifier)
			} else {
				annotationView?.annotation = customAnnotation
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
	}
	
	func stopUpdating() {
		locationManager?.stopUpdatingLocation()
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
		//오류 너무나서 안되겠다
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let polylineOverlay = overlay as? MKPolyline {
			let renderer = MKPolylineRenderer(polyline: polylineOverlay)
			renderer.strokeColor = .blue
			renderer.lineWidth = 5
			return renderer
		}
		return MKOverlayRenderer()
	}
	
	private func setupLocationManager() {
		self.locationManager = CLLocationManager()
		self.locationManager!.delegate = self
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
}

enum UserTrackingMode {
	case none
	case follow
	case followWithHeading
}
