//
//  SnapshotManager.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/27.
//

import MapKit

class SnapshotManager {
	static func takeSnapshot(mapView: MKMapView, multiPolyline: MKMultiPolyline, completion: @escaping (UIImage?) -> Void) {
		let options = configureSnapshotterOptions(mapView: mapView, multiPolyline: multiPolyline)
		let snapshotter = MKMapSnapshotter(options: options)
		snapshotter.start { snapshot, error in
			guard let snapshot = snapshot else {
				print(error?.localizedDescription ?? "No error")
				completion(nil)
				return
			}
			let image = renderSnapshotImage(options: options, snapshot: snapshot, multiPolyline: multiPolyline)
			completion(image)
		}
	}
	
	private static func configureSnapshotterOptions(mapView: MKMapView, multiPolyline: MKMultiPolyline) -> MKMapSnapshotter.Options {
		let options = MKMapSnapshotter.Options()
		
		let width = UIScreen.main.bounds.width
		options.size = CGSize(width: width, height: width)
		options.scale = UIScreen.main.scale
		
		options.region = region(for: multiPolyline)
		return options
	}

	private static func renderSnapshotImage(options: MKMapSnapshotter.Options, snapshot: MKMapSnapshotter.Snapshot, multiPolyline: MKMultiPolyline) -> UIImage {
		let renderer = UIGraphicsImageRenderer(size: options.size)
		let image = renderer.image { _ in
			snapshot.image.draw(at: CGPoint.zero)
			drawMultiPolyline(multiPolyline, snapshot: snapshot)
		}
		return image
	}

	private static func drawMultiPolyline(_ multiPolyline: MKMultiPolyline, snapshot: MKMapSnapshotter.Snapshot) {
		for polyline in multiPolyline.polylines {
			let path = UIBezierPath()
			for (index, coordinate) in polyline.coordinates.enumerated() {
				let point = snapshot.point(for: coordinate)
				if index == 0 {
					path.move(to: point)
				} else {
					path.addLine(to: point)
				}
			}

			UIColor(red: 40/255, green: 203/255, blue: 174/255, alpha: 1).setStroke()
			path.lineWidth = 5
			path.stroke()
		}
	}

	private static func region(for multiPolyline: MKMultiPolyline) -> MKCoordinateRegion {
		var regionRect = multiPolyline.boundingMapRect

		let wPadding = regionRect.size.width * 0.5
		let hPadding = regionRect.size.height * 0.5

		regionRect.size.width += wPadding
		regionRect.size.height += hPadding
		regionRect.origin.x -= wPadding / 2
		regionRect.origin.y -= hPadding / 2

		return MKCoordinateRegion(regionRect)
	}
}
