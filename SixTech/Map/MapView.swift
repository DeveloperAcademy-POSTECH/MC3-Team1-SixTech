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
	
	var body: some View {
		ZStack {
			Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
				.ignoresSafeArea()
		}
	}
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
