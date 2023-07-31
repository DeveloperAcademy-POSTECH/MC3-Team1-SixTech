//
//  MKPolyline+Coordinates.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/27.
//

import MapKit

extension MKPolyline {
	var coordinates: [CLLocationCoordinate2D] {
		var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: self.pointCount)
		self.getCoordinates(&coords, range: NSRange(location: 0, length: self.pointCount))
		return coords
	}
}
