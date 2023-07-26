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
                Text(motionManager.isCollectingData ? "데이터 수집 중!" : "데이터 수집 시작 (6초간)")
            }
        }
        .onAppear {
            motionManager.startMotionUpdates()
        }
    }
}


class MotionManager: NSObject, ObservableObject, WCSessionDelegate {
    private var motionManager: CMMotionManager?
    private var data: [(userAcceleration: CMAcceleration, rotationRate: CMRotationRate)] = []
    private var timer: Timer? = nil
    private var backgroundSession: WKExtendedRuntimeSession?
    
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
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 50.0, repeats: true) { _ in
            guard let motion = self.deviceMotion else { return }
            self.data.append((userAcceleration: motion.userAcceleration, rotationRate: motion.rotationRate))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
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
    }
    
    func sendToiPhone() {
//        if WCSession.default.isReachable {
//            let dataToSend = data.map {
//                ["userAcceleration": ["x": $0.userAcceleration.x, "y": $0.userAcceleration.y, "z": $0.userAcceleration.z],
//                 "rotationRate": ["x": $0.rotationRate.x, "y": $0.rotationRate.y, "z": $0.rotationRate.z]]
//            }
//            WCSession.default.sendMessage(["sensorData": dataToSend], replyHandler: nil)
//        }
        
        let dataToSend = data.map {
            ["userAcceleration": ["x": $0.userAcceleration.x, "y": $0.userAcceleration.y, "z": $0.userAcceleration.z],
             "rotationRate": ["x": $0.rotationRate.x, "y": $0.rotationRate.y, "z": $0.rotationRate.z]]
        }

        let _ = WCSession.default.transferUserInfo(["sensorData": dataToSend])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
