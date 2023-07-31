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
import CoreML

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
                Text(motionManager.isCollectingData ? "데이터 수집 중!" : "예측 시작")
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
    
    // Core ML model 관련 변수
    private let model: WatchMotionClassifier
    private var predictionCounter = 0
    private var canPredict = true
    
    override init() {
        // 모델 로드
        guard let model = try? WatchMotionClassifier(configuration: MLModelConfiguration()) else {
            fatalError("Failed to load ML model.")
        }
        self.model = model
        
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
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 50.0, repeats: true) { _ in
            guard let motion = self.deviceMotion else { return }
            
            let elapsed = Date().timeIntervalSince1970 - startTime
            
            self.data.append((timestamp: elapsed, userAcceleration: motion.userAcceleration, rotationRate: motion.rotationRate, attitude: motion.attitude, gravity: motion.gravity))
            
            // 실시간으로 데이터를 모델에 제공하고 예측 결과를 처리
            if self.canPredict {
                self.makePrediction(with: motion)
            }
        }
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        //            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 50.0, repeats: true) { _ in
        //                guard let motion = self.deviceMotion else { return }
        //
        //                let elapsed = Date().timeIntervalSince1970 - startTime
        //
        //                self.data.append((timestamp: elapsed, userAcceleration: motion.userAcceleration, rotationRate: motion.rotationRate, attitude: motion.attitude, gravity: motion.gravity))
        //            }
        //        }
        //
        //
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 9.0) {
        //            self.stopCollectingData()
        //        }
    }
    
    // Core ML 모델을 사용하여 예측 수행
    private func makePrediction(with motion: CMDeviceMotion) {
        // featureValues 생성
        let featureValues = [motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z, motion.rotationRate.x, motion.rotationRate.y, motion.rotationRate.z]
        guard let mlArray = try? MLMultiArray(shape: [NSNumber(value: featureValues.count)], dataType: .double) else {
            print("Failed to create MLMultiArray.")
            return
        }
        for (index, element) in featureValues.enumerated() {
            mlArray[index] = NSNumber(value: element)
        }
        
        // 예측 수행
        guard let prediction = try? self.model.prediction(input: WatchMotionClassifierInput(sensorData: mlArray)) else {
            print("Failed to make prediction.")
            return
        }
        
        if prediction.classLabelProbs[prediction.classLabel] ?? 0 > 0.8 {
            self.predictionCounter += 1
            self.canPredict = false
            
            // 2초 동안 예측 중단
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.canPredict = true
            }
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
