//
//  ImageAnnotationView.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/19.
//

import MapKit

class ImageAnnotationView: MKAnnotationView {
	static let identifier = "ImageAnnotationView"

	override var annotation: MKAnnotation? {
		willSet {
			guard let imageAnnotation = newValue as? ImageAnnotation else { return }

			canShowCallout = false
			image = imageAnnotation.image
			frame = CGRect(x: 0, y: 0, width: 50, height: 50)
			centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
		}
	}
}

class ImageAnnotation: NSObject, MKAnnotation {
	let image: UIImage?
	let coordinate: CLLocationCoordinate2D

	init(image: UIImage?, coordinate: CLLocationCoordinate2D) {
		self.image = image
		self.coordinate = coordinate

		super.init()
	}
}
