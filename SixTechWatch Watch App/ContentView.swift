//
//  ContentView.swift
//  SixTechWatch Watch App
//
//  Created by 이재원 on 2023/07/20.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @StateObject var motionManager = MotionManager()
    
    var body: some View {
        VStack {
//            Text("User Acceleration:")
//            Text("X: \(String(format: "%.2f", motionManager.deviceMotion?.userAcceleration.x ?? 0))")
//            Text("Y: \(String(format: "%.2f", motionManager.deviceMotion?.userAcceleration.y ?? 0))")
//            Text("Z: \(String(format: "%.2f", motionManager.deviceMotion?.userAcceleration.z ?? 0))")
//
//            Text("Rotation Rate:")
//            Text("X: \(String(format: "%.2f", motionManager.deviceMotion?.rotationRate.x ?? 0))")
//            Text("Y: \(String(format: "%.2f", motionManager.deviceMotion?.rotationRate.y ?? 0))")
//            Text("Z: \(String(format: "%.2f", motionManager.deviceMotion?.rotationRate.z ?? 0))")
            Text("허리 굽힌 횟수:")
            Text("\(motionManager.pickCount)")
        }
        .onAppear {
            motionManager.startMotionUpdates()
        }
    }
}


class MotionManager: ObservableObject {
    private var motionManager: CMMotionManager?
    private var isCounting: Bool = false
    private var workItem: DispatchWorkItem?
    
    @Published var deviceMotion: CMDeviceMotion?
    @Published var pickCount: Int = 0
    
    init() {
        if CMMotionManager().isDeviceMotionAvailable {
            self.motionManager = CMMotionManager()
        }
    }
    
    func startMotionUpdates() {
        motionManager?.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager?.startDeviceMotionUpdates(to: .main) { (data, error) in
            guard let data = data else { return }
            self.deviceMotion = data
            
            if abs(data.userAcceleration.y) > 1.0 && !self.isCounting {
                self.pickCount += 1
                self.isCounting = true

                // If there is an existing work item, cancel it
                self.workItem?.cancel()

                // Create a new work item
                self.workItem = DispatchWorkItem { [weak self] in
                    self?.isCounting = false
                }

                // Execute the work item after 3 seconds
                if let workItem = self.workItem {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: workItem)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
