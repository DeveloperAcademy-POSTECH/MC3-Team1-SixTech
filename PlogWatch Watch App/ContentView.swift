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
//            Text("User Acceleration:")
//            Text("X: \(String(format: "%.2f", motionManager.deviceMotion?.userAcceleration.x ?? 0))")
//            Text("Y: \(String(format: "%.2f", motionManager.deviceMotion?.userAcceleration.y ?? 0))")
//            Text("Z: \(String(format: "%.2f", motionManager.deviceMotion?.userAcceleration.z ?? 0))")
//
//            Text("Rotation Rate:")
//            Text("X: \(String(format: "%.2f", motionManager.deviceMotion?.rotationRate.x ?? 0))")
//            Text("Y: \(String(format: "%.2f", motionManager.deviceMotion?.rotationRate.y ?? 0))")
//            Text("Z: \(String(format: "%.2f", motionManager.deviceMotion?.rotationRate.z ?? 0))")
            Text("\(motionManager.predictionCounter)")
            Text("\(motionManager.attMax)")
            Text("\(motionManager.attMin)")
//            Text("\(motionManager.predictionCounter2)")
//            Text("Prediction Label: \(motionManager.predictionLabel)")
//            Text("Prediction Probability: \(motionManager.predictionProbability)")
//            Text("Predictions: \(motionManager.numOfPrediction)")
//            Text("Error: \(motionManager.predictionErrorMessage)")
            
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
    var predictionCounter: Int = 0
    var predictionCounter2: Int = 0
    var numOfPrediction: Int = 0
    var predictionErrorMessage = ""
    private var canPredict = true
    private var previousStateOut: MLMultiArray?
//    var predictionLabel = ""
    var predictionProbability: Double = 0.0
    
    var attMax: Double = 0.0
    var attMin: Double = 0.0
    
    
    // Core ML 예측 데이터 (Double형의 100개짜리 MLMultiArray)
    private var acceleration_x = [Double]()
    private var acceleration_y = [Double]()
    private var acceleration_z = [Double]()
    private var rotation_x = [Double]()
    private var rotation_y = [Double]()
    private var rotation_z = [Double]()
    private var attitude_yaw = [Double]()
    private var timestamps = [Double]()
    
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
        
        // CoreML Input Data
        self.acceleration_x = []
        self.acceleration_y = []
        self.acceleration_z = []
        self.rotation_x = []
        self.rotation_y = []
        self.rotation_z = []
        self.attitude_yaw = []
        self.timestamps = []
        
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
            
            // for prediction
            self.appendDataKeepingSizeLimit(motion.userAcceleration.x, to: &self.acceleration_x)
            self.appendDataKeepingSizeLimit(motion.userAcceleration.y, to: &self.acceleration_y)
            self.appendDataKeepingSizeLimit(motion.userAcceleration.z, to: &self.acceleration_z)
            self.appendDataKeepingSizeLimit(motion.rotationRate.x, to: &self.rotation_x)
            self.appendDataKeepingSizeLimit(motion.rotationRate.y, to: &self.rotation_y)
            self.appendDataKeepingSizeLimit(motion.rotationRate.z, to: &self.rotation_z)
            self.appendDataKeepingSizeLimit(motion.attitude.yaw, to: &self.attitude_yaw)
            self.appendDataKeepingSizeLimit(elapsed, to: &self.timestamps)
                        
            // 실시간으로 데이터를 모델에 제공하고 예측 결과를 처리
            if self.canPredict && self.acceleration_x.count >= 100 {
//                self.makePrediction(with: motion)
                self.attMax = self.attitude_yaw.max() ?? 0
                self.attMin = self.attitude_yaw.min() ?? 0
                if self.attMax - self.attMin > 5 {
                    self.predictionCounter += 1
                    self.canPredict = false
                    
                    // 2초 동안 예측 중단
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        self.canPredict = true
                    }
                }
            }
        }
    }
    
    func appendDataKeepingSizeLimit(_ value: Double, to array: inout [Double]) {
        array.append(value)
        
        while array.count > 100 {
            array.remove(at: 0)
        }
    }
    
    // Core ML 모델을 사용하여 예측 수행
    private func makePrediction(with motion: CMDeviceMotion) {
        // MLMultiArray로 예측 데이터 parsing.
        guard let accel_x = try? MLMultiArray(self.acceleration_x),
              let accel_y = try? MLMultiArray(self.acceleration_y),
              let accel_z = try? MLMultiArray(self.acceleration_z),
              let rot_x = try? MLMultiArray(self.rotation_x),
              let rot_y = try? MLMultiArray(self.rotation_y),
              let rot_z = try? MLMultiArray(self.rotation_z),
              let timestamp = try? MLMultiArray(self.timestamps) else {
            print("Failed to create MLMultiArray.")
            return
        }
        let defaultState = try? MLMultiArray(shape:[400], dataType:MLMultiArrayDataType.double)

        for i in 0..<defaultState!.count {
            defaultState![i] = 0.0
        }

//        let stateIn = self.previousStateOut ?? defaultState
//        guard let safeStateIn = stateIn else {
//            self.predictionErrorMessage = "stateIn is nil."
//            return
//        }
        
        let stateIn = defaultState
        
        // WatchMotionClassifierOutput (MLFeatureProvider protocol)
        do {
            let prediction = try self.model.prediction(acceleration_x: accel_x, acceleration_y: accel_y, acceleration_z: accel_z, rotation_x: rot_x, rotation_y: rot_y, rotation_z: rot_z, timestamp: timestamp, stateIn: stateIn!)
            
//            self.predictionLabel = prediction.label
            self.predictionProbability = prediction.labelProbability["Plogging", default: 0.0]
            if prediction.labelProbability["Plogging", default: 0.0] > 0.95 {
                self.predictionCounter += 1
                self.canPredict = false
                
                // 2초 동안 예측 중단
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.canPredict = true
                }
                
                // 이전 예측의 상태 저장
                self.previousStateOut = prediction.stateOut
            } else if prediction.labelProbability["Plogging2", default: 0.0] > 0.95 {
                self.predictionCounter += 1
                self.canPredict = false
                
                // 2초 동안 예측 중단
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.canPredict = true
                }
                
                // 이전 예측의 상태 저장
                self.previousStateOut = prediction.stateOut
            }
        } catch {
            self.predictionErrorMessage = error.localizedDescription
            self.numOfPrediction += 1
            return
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
            ] as [String : Any]
        }
        
        let _ = WCSession.default.transferUserInfo(["sensorData": dataToSend])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
