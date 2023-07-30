//
//  SnapshotManager.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/27.
//

import MapKit

class SnapshotManager {
	static func takeSnapshot(mapView: MKMapView, polyline: MKPolyline, completion: @escaping (UIImage?) -> Void) {
		let options = configureSnapshotterOptions(mapView: mapView, polyline: polyline)
		let snapshotter = MKMapSnapshotter(options: options)
		snapshotter.start { snapshot, error in
			guard let snapshot = snapshot else {
				print(error?.localizedDescription ?? "No error")
				completion(nil)
				return
			}
			let image = renderSnapshotImage(options: options, snapshot: snapshot, polyline: polyline)
			completion(image)
		}
	}
	
	private static func configureSnapshotterOptions(mapView: MKMapView, polyline: MKPolyline) -> MKMapSnapshotter.Options {
		let options = MKMapSnapshotter.Options()
		options.region = region(for: polyline)
		options.size = mapView.frame.size
		options.scale = UIScreen.main.scale
		return options
	}

	private static func renderSnapshotImage(options: MKMapSnapshotter.Options, snapshot: MKMapSnapshotter.Snapshot, polyline: MKPolyline) -> UIImage {
		let renderer = UIGraphicsImageRenderer(size: options.size)
		let image = renderer.image { _ in
			snapshot.image.draw(at: CGPoint.zero)
			drawPolyline(polyline, snapshot: snapshot)
		}
		return image
	}

	private static func drawPolyline(_ polyline: MKPolyline, snapshot: MKMapSnapshotter.Snapshot) {
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

	private static func region(for polyline: MKPolyline) -> MKCoordinateRegion {
		var regionRect = polyline.boundingMapRect
		let wPadding = regionRect.size.width * 0.5
		let hPadding = regionRect.size.height * 0.5

		regionRect.size.width += wPadding
		regionRect.size.height += hPadding
		regionRect.origin.x -= wPadding / 2
		regionRect.origin.y -= hPadding / 2

		return MKCoordinateRegion(regionRect)
	}
}
