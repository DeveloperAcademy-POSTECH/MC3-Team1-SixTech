//
//  CustomAnnotationView.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/19.
//

import MapKit

class CustomAnnotationView: MKAnnotationView {
	static let identifier = "CustomAnnotationView"

	override var annotation: MKAnnotation? {
		willSet {
			guard let customAnnotation = newValue as? CustomAnnotation else { return }

			canShowCallout = false
			image = customAnnotation.image
			frame = CGRect(x: 0, y: 0, width: 50, height: 50)
			centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
		}
	}
}

class CustomAnnotation: NSObject, MKAnnotation {
	let image: UIImage?
	let coordinate: CLLocationCoordinate2D

	init(image: UIImage?, coordinate: CLLocationCoordinate2D) {
		self.image = image
		self.coordinate = coordinate

		super.init()
	}
}
