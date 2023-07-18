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
			VStack {
				Spacer()
				HStack {
					Spacer()
					Button {
						locationManager.trackUser.toggle()
						if locationManager.trackUser {
							locationManager.startUpdating()
						} else {
							locationManager.stopUpdating()
						}
					} label: {
						Image(systemName: locationManager.trackUser ? "location.fill" : "location")
							.padding()
							.clipShape(Circle())
					}
					.padding()
				}
			}
		}
	}
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
