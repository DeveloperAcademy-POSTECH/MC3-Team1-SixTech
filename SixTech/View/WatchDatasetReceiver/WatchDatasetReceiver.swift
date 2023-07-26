//
//  WatchDatasetReciever.swift
//  SixTech
//
//  Created by 이재원 on 2023/07/26.
//

import SwiftUI
import WatchConnectivity

class DataReceiver: NSObject, ObservableObject, WCSessionDelegate {
    @Published var receivedData: [(String, [String: Double])] = []

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }

    func sessionDidDeactivate(_ session: WCSession) {
        //
    }

    override init() {
        super.init()

        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("WCSession Activated - iPhone")
        }
    }

//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        if let dataArray = message["sensorData"] as? [[String: [String: Double]]] {
//            DispatchQueue.main.async {
//                for data in dataArray {
//                    for (key, value) in data {
//                        self.receivedData.append((key, value))
//                    }
//                }
//            }
//        }
//    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let dataArray = userInfo["sensorData"] as? [[String: [String: Double]]] {
            DispatchQueue.main.async {
                for data in dataArray {
                    for (key, value) in data {
                        self.receivedData.append((key, value))
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
            ForEach(dataReceiver.receivedData, id: \.0) { (time, data) in
                VStack(alignment: .leading) {
                    Text("Time: \(time)")
                    ForEach(data.sorted(by: <), id: \.key) { key, value in
                        Text("\(key): \(value)")
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
