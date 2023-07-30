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
	@State private var snapshottedMap = UIImage()
    @State var isNextView = false

    @State var isAlert = false

    var body: some View {
        
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
                    }
                    .padding()
                }
                Spacer()
                ActivityDataView(alert: { isalert in
                    self.isAlert = isalert
                })
                    .padding(.bottom)
                    .padding(.bottom)
                
                Button {
                    SnapshotManager.takeSnapshot(mapView: locationManager.mapView,
                                                 polyline: locationManager.polylines) { image in
                        if let image = image {
                            snapshottedMap = image
                        } else { return }
                    }
                } label: {
                    Text("Snapshot")
                }
//                NavigationLink(destination: TestPhotoView(snapshot: $snapshottedMap)) {
//                    Text("gotosnapshot")
//                }
                NavigationLink("dfdf", isActive: $isNextView) {
                    ImagePickView()
                }
                .navigationBarBackButtonHidden()
            }
        }
        .alert(title: "플로깅 완료", message: "플로깅을 끝내시겠어요?", primaryButton: CustomAlertButton(title: "완료", action: { isNextView = true}), secondaryButton: CustomAlertButton(title: "취소", action: { isAlert = false }), isPresented: $isAlert)
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

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
