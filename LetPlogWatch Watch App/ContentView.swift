//
//  ContentView.swift
//  LetPlogWatch Watch App
//
//  Created by 이재원 on 2023/07/26.
//

import SwiftUI
import CoreMotion
import WatchConnectivity
import WatchKit
import HealthKit

struct ContentView: View {
    @StateObject var motionManager = MotionManager()
    
    var body: some View {
        VStack {
            Text("User Acceleration:")
            Text("X: \(String(format: "%.2f", motionManager.deviceMotion?.userAcceleration.x ?? 0))")
            Text("Y: \(String(format: "%.2f", motionManager.deviceMotion?.userAcceleration.y ?? 0))")
            Text("Z: \(String(format: "%.2f", motionManager.deviceMotion?.userAcceleration.z ?? 0))")
            
            Text("Rotation Rate:")
            Text("X: \(String(format: "%.2f", motionManager.deviceMotion?.rotationRate.x ?? 0))")
            Text("Y: \(String(format: "%.2f", motionManager.deviceMotion?.rotationRate.y ?? 0))")
            Text("Z: \(String(format: "%.2f", motionManager.deviceMotion?.rotationRate.z ?? 0))")
            
            Button(action: {
                if !motionManager.isCollectingData{
                    motionManager.startCollectingData()
                }
            }) {
                Text(motionManager.isCollectingData ? "데이터 수집 중!" : "데이터 수집 시작 (10초간)")
            }
        }
        .onAppear {
            motionManager.startMotionUpdates()
        }
    }
}


class MotionManager: NSObject, ObservableObject, WCSessionDelegate {
    private var motionManager: CMMotionManager?
    private var data: [(timestamp: TimeInterval, userAcceleration: CMAcceleration, rotationRate: CMRotationRate, attitude: CMAttitude, gravity: CMAcceleration)] = []
    private var timer: Timer? = nil
    
    private var backgroundSession: WKExtendedRuntimeSession?
    private var healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    
    @Published var deviceMotion: CMDeviceMotion?
    @Published var isCollectingData = false
    
    override init() {
        super.init()
        
        if CMMotionManager().isDeviceMotionAvailable {
            self.motionManager = CMMotionManager()
        }
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("WCSession Activated - Apple Watch")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation of session
    }
    
    func startMotionUpdates() {
        motionManager?.deviceMotionUpdateInterval = 1.0 / 50.0
        motionManager?.startDeviceMotionUpdates(to: .main) { (data, error) in
            guard let data = data else { return }
            self.deviceMotion = data
        }
    
    }
    
    func startCollectingData() {
        self.isCollectingData = true
        self.backgroundSession = WKExtendedRuntimeSession()
        self.backgroundSession?.start()
        
        let startTime = Date().timeIntervalSince1970
        // Start the HealthKit workout session
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .running
        do {
            self.workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            self.workoutSession?.startActivity(with: Date())
        } catch {
            print("Failed to start workout session: \(error.localizedDescription)")
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 50.0, repeats: true) { _ in
                guard let motion = self.deviceMotion else { return }
                
                let elapsed = Date().timeIntervalSince1970 - startTime
                
                self.data.append((timestamp: elapsed, userAcceleration: motion.userAcceleration, rotationRate: motion.rotationRate, attitude: motion.attitude, gravity: motion.gravity))
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 9.0) {
            self.stopCollectingData()
        }
    }
    
    func stopCollectingData() {
        self.timer?.invalidate()
        self.timer = nil
        
        sendToiPhone()
        data.removeAll()
        self.isCollectingData = false
        
        self.backgroundSession?.invalidate()
        self.backgroundSession = nil
        // Stop the HealthKit workout session
        self.workoutSession?.stopActivity(with: Date())
        self.workoutSession?.end()
        self.workoutSession = nil
    }
    
    func sendToiPhone() {
        let dataToSend = data.map {
            [
                "timestamp": $0.timestamp,
                "userAcceleration": [
                    "x": $0.userAcceleration.x,
                    "y": $0.userAcceleration.y,
                    "z": $0.userAcceleration.z
                ],
                "rotationRate": [
                    "x": $0.rotationRate.x,
                    "y": $0.rotationRate.y,
                    "z": $0.rotationRate.z
                ],
                "attitude": [
                    "pitch": $0.attitude.pitch,
                    "roll": $0.attitude.roll,
                    "yaw": $0.attitude.yaw
                ],
                "gravity": [
                    "x": $0.gravity.x,
                    "y": $0.gravity.y,
                    "z": $0.gravity.z
                ]
            ]
        }
        
        let _ = WCSession.default.transferUserInfo(["sensorData": dataToSend])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
