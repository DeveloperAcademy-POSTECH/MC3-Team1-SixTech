//
//  WatchManager.swift
//  SixTech
//
//  Created by 이재원 on 2023/08/31.
//

import WatchConnectivity
import SwiftUI

class SessionManager: NSObject, WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
    
    static let shared = SessionManager()
    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // 메시지 보내기 (watch로)
    func sendMessage() {
        let message = ["Value": true]
        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
    
    // WCSessionDelegate 메서드
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // 세션이 활성화되면 호출됩니다.
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // watch에서 메시지를 받으면 호출됩니다.
        if let dataFromWatch = message["Value"] as? Bool {
            print("Received from watch: \(dataFromWatch)")
        }
    }
}
