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
	@State private var mapSnapshot = UIImage()

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
								.overlay(Circle().stroke(lineWidth: 0.05))
						}
						.padding()
					}
					Spacer()
					ActivityDataView()
						.padding(.bottom)
						.padding(.bottom)
					
					Button {
						takeSnapshot(mapView: locationManager.mapView, polyline: locationManager.polylines) { image in
							if let image = image {
								self.mapSnapshot = image
							} else { return }
						}
					} label: {
						Text("Snapshot")
					}
					NavigationLink(destination: TestPhotoView(snapshot: $mapSnapshot)) {
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

extension MKPolyline {
	var coordinates: [CLLocationCoordinate2D] {
		var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: self.pointCount)
		self.getCoordinates(&coords, range: NSRange(location: 0, length: self.pointCount))
		return coords
	}
}

func takeSnapshot(mapView: MKMapView, polyline: MKPolyline, completion: @escaping (UIImage?) -> Void) {
	let options = MKMapSnapshotter.Options()
	options.region = region(for: polyline)
	options.size = mapView.frame.size
	options.scale = UIScreen.main.scale
	
	let snapshotter = MKMapSnapshotter(options: options)
	snapshotter.start { snapshot, error in
		guard let snapshot = snapshot else {
			print("Unable to take a snapshot of the map: \(error?.localizedDescription ?? "No error provided.")")
			completion(nil)
			return
		}
		
		let renderer = UIGraphicsImageRenderer(size: options.size)
		let image = renderer.image { _ in
			snapshot.image.draw(at: CGPoint.zero)
			
			let path = UIBezierPath()
			for (index, coordinate) in polyline.coordinates.enumerated() {
				let point = snapshot.point(for: coordinate)
				if index == 0 {
					path.move(to: point)
				} else {
					path.addLine(to: point)
				}
			}
			
			UIColor.blue.setStroke()
			path.lineWidth = 5
			path.stroke()
		}
		
		completion(image)
	}
}

func region(for polyline: MKPolyline) -> MKCoordinateRegion {
	var regionRect = polyline.boundingMapRect

	let wPadding = regionRect.size.width * 0.25
	let hPadding = regionRect.size.height * 0.25

	regionRect.size.width += wPadding
	regionRect.size.height += hPadding

	regionRect.origin.x -= wPadding / 2
	regionRect.origin.y -= hPadding / 2

	return MKCoordinateRegion(regionRect)
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
