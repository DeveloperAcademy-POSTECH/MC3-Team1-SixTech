//
//  InfoView.swift
//  SixTech
//
//  Created by Junyoo on 2023/07/24.
//

import SwiftUI

struct ActivityDataView: View {
    @EnvironmentObject var ploggingManager: PloggingManager
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var userInfo: UserInfo
    @State private var pauseTapped = false
    @Binding var isAlert: Bool
    
    var movedDistance: String {
        String(format: "%.1f", locationManager.movedDistance / 1000)
    }
    
    var steps: String {
        (ploggingManager.totalStep + ploggingManager.currentStep).formatWithDot
    }
    
    var pickedCount: String {
        ploggingManager.pickedCount.formatWithDot
    }

    var ploogingCount: String = 1000.formatWithDot

    var body: some View {
        ZStack {
            VStack {
                RectangleView {
                    VStack {
                        Spacer()
                        TrackingInfoView(kilometer: movedDistance,
                                         steps: steps,
                                         pickups: pickedCount)
                        Spacer()
                        if pauseTapped {
                            ElapsedTimeView(time: ploggingManager.formattedElapsedTime)
                        }
                    }
                }
                .frame(maxHeight: pauseTapped ? 170 : 70)
                if pauseTapped {
                    RectangleView {
                        MissionView(mission: userInfo.myMission)
                    }
                }
                
                if pauseTapped {
                    HStack {
                        ControlButtonView(buttonType: .stop) {
                            SnapshotManager.takeSnapshot(mapView: locationManager.mapView,
                                                         multiPolyline: locationManager.polylines) { image in
                                if let image = image {
                                    ploggingManager.snapshottedMap = image
                                }
                            }
                            isAlert = true
                        }
                        .padding(.bottom)
                        .padding(.horizontal)
                        
                        ControlButtonView(buttonType: .play) {
                            self.pauseTapped = false
                            ploggingManager.startPedometer()
                            locationManager.startUpdating()
                        }
                        .padding(.bottom)
                        .padding(.horizontal)
                    }
                } else {
                    ControlButtonView(buttonType: .pause) {
                        self.pauseTapped = true
                        ploggingManager.totalStep += ploggingManager.currentStep
                        ploggingManager.stopPedometer()
                        locationManager.stopUpdating()
                    }
                    .padding(.bottom)
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(.white.opacity(0.8))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
        }
    }
}

struct TrackingInfoView: View {
    var kilometer: String
    var steps: String
    var pickups: String

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(kilometer)
                    .font(.Jamsil.medium.font(size: 25))
                    .foregroundColor(.fontColor)
                Text("km")
                    .font(.Jamsil.light.font(size: 12))
            }
            Spacer()
            VStack {
                Text(steps)
                    .font(.Jamsil.medium.font(size: 25))
                    .foregroundColor(.fontColor)
                Text("걸음")
                    .font(.Jamsil.light.font(size: 12))
            }
            Spacer()
            VStack {
                Text(pickups)
                    .font(.Jamsil.medium.font(size: 25))
                    .foregroundColor(.fontColor)
                Text("줍깅")
                    .font(.Jamsil.light.font(size: 12))
            }
            Spacer()
        }
    }
}

struct ElapsedTimeView: View {
    var time: String

    var body: some View {
        VStack {
            Text(time)
                .font(.Jamsil.bold.font(size: 40))
                .kerning(4)
                .foregroundColor(.accentFontColor)
            Text("경과 시간")
                .font(.Jamsil.light.font(size: 12))
                .padding(.bottom)
        }
    }
}

struct MissionView: View {
    var mission: String

    var body: some View {
        VStack {
            Text("나의 같이줍깅 미션")
                .font(.Jamsil.light.font(size: 16))
                .padding(.top)
            Spacer()
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: 270, maxHeight: 40)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.horizontal)
                .overlay {
                    Text(mission)
                        .font(.Jamsil.regular.font(size: 16))
                }
            Spacer()
            RoundedRectangle(cornerRadius: 35)
                .frame(maxWidth: 270, maxHeight: 40)
                .shadow(color: .gray.opacity(0.5), radius: 2.5, x: 0, y: 2)
                .foregroundColor(.defaultColor)
                .padding(.horizontal)
                .padding(.horizontal)
                .overlay {
                    NavigationLink {
                        CameraFilterView()
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("미션 하러 가기")
                                .font(.Jamsil.bold.font(size: 14))
                        }
                        .foregroundColor(.white)
                    }
                }
            Spacer()
        }
    }
}

private struct ControlButtonView: View {
    var buttonType: ControlButtonType
    var buttonAction: () -> Void

    var body: some View {
        Button(action: buttonAction) {
            Image(systemName: buttonType.systemName)
                .font(.system(size: 35))
                .bold()
//                .shadow(radius: 0, x: 1, y: 1)
                .foregroundColor(.red)
                .padding(.all, 25)
                .background {
                    Circle()
                        .foregroundColor(.buttonBackgroundColor)
                        .shadow(color: .black.opacity(0.15), radius: 2.5, x: 1, y: 1)
                }
        }
    }
}

private enum ControlButtonType {
    case stop, play, pause

    var systemName: String {
        switch self {
        case .stop:
            return "stop.fill"
        case .play:
            return "play.fill"
        case .pause:
            return "pause.fill"
        }
    }
}
