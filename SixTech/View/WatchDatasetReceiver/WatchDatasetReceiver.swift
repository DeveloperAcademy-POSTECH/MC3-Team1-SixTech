//
//  WatchDatasetReciever.swift
//  SixTech
//
//  Created by 이재원 on 2023/07/26.
//

import Foundation
import SwiftUI
import WatchConnectivity

class DataReceiver: NSObject, ObservableObject, WCSessionDelegate {
    @Published var receivedData: [(timestamp: Double, sensorData: [String: [String: Double]])] = []

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }

    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
    
    private func writeToFile(_ string: String, fileURL: URL) {
        do {
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                try string.write(to: fileURL, atomically: true, encoding: .utf8)
            } else {
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                if let data = string.data(using: .utf8) {
                    fileHandle.write(data)
                }
                fileHandle.closeFile()
            }
        } catch {
            print("Error writing to file: \(error)")
        }
    }


    override init() {
        super.init()

        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("WCSession Activated - iPhone")
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("Gyroscope data received")
        if let dataArray = userInfo["sensorData"] as? [[String: Any]] {
            print("Gyroscope data parsing")
            
            // 파일매니저, 시간정보 포함 데이터셋 파일명
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss" // Or any format you want.
            let dateString = dateFormatter.string(from: Date())
            let fileURL = documentsDirectory.appendingPathComponent("data_\(dateString).csv")

            // CSV의 첫 줄(헤더)을 작성
            let header = "timestamp,acceleration_x,acceleration_y,acceleration_z,attitude_pitch,attitude_roll,attitude_yaw,gravity_x,gravity_y,gravity_z,rotation_x,rotation_y,rotation_z\n"
            writeToFile(header, fileURL: fileURL)
            
            DispatchQueue.main.async {
                var currentTime: Double = 0.00
                let timeStep: Double = 0.02
                for data in dataArray {
                    if let timestamp = data["timestamp"] as? Double {
                        currentTime += timeStep
                        var sensorData: [String: [String: Double]] = [:]
                        for (key, value) in data {
                            if key != "timestamp", let value = value as? [String: Double] {
                                sensorData[key] = value
                            }
                        }
                        self.receivedData.append((timestamp: currentTime, sensorData: sensorData))
                        
                        // 데이터를 CSV 형식으로 작성하고, 파일에 추가
                        let acceleration = sensorData["userAcceleration"] ?? ["x": 0.0, "y": 0.0, "z": 0.0]
                        let rotation = sensorData["rotationRate"] ?? ["x": 0.0, "y": 0.0, "z": 0.0]
                        let attitude = sensorData["attitude"] ?? ["pitch": 0.0, "roll": 0.0, "yaw": 0.0]
                        let gravity = sensorData["gravity"] ?? ["x": 0.0, "y": 0.0, "z": 0.0]
                        // Timestamp 소수점 둘째자리까지
                        let currentTimeString = String(format: "%.2f", currentTime)
                        let row = "\(currentTimeString),\(acceleration["x"]!),\(acceleration["y"]!),\(acceleration["z"]!),\(attitude["pitch"]!),\(attitude["roll"]!),\(attitude["yaw"]!),\(gravity["x"]!),\(gravity["y"]!),\(gravity["z"]!),\(rotation["x"]!),\(rotation["y"]!),\(rotation["z"]!)\n"
                        self.writeToFile(row, fileURL: fileURL)
                    }
                }
            }
        }
    }
}

struct WatchDatasetReceiverView: View {
    @ObservedObject var dataReceiver = DataReceiver()

    var body: some View {
        ScrollView {
            ForEach(dataReceiver.receivedData, id: \.timestamp) { item in
                VStack(alignment: .leading) {
                    Text("Timestamp: \(item.timestamp)")
                    ForEach(item.sensorData.keys.sorted(), id: \.self) { key in
                        VStack(alignment: .leading) {
                            Text(key).font(.headline)
                            ForEach(item.sensorData[key]!.sorted(by: <), id: \.key) { innerKey, innerValue in
                                Text("\(innerKey): \(innerValue)")
                            }
                        }
                    }
                }
                .padding(.bottom, 10)
            }
        }
    }
}




struct WatchDatasetReciever_Previews: PreviewProvider {
    static var previews: some View {
        WatchDatasetReceiverView()
    }
}
