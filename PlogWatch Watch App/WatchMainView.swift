//
//  WatchMainView.swift
//  PlogWatch Watch App
//
//  Created by 이재원 on 2023/08/02.
//

import SwiftUI
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    @Published var isCountDownPresented: Bool = false
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // 액션 핸들러
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let value = message["Value"] as? Bool, value {
            // iOS에서 건네받은 Value == true이면 isCountDownPresented = true로 바꿈
            isCountDownPresented = true
        }
    }
}

struct WatchMainView: View {
    @StateObject var WCSessionManager: WatchSessionManager = WatchSessionManager()
    
    var body: some View {
        VStack {
            Text("같이줍깅")
                .font(.Jamsil.bold.font(size: 18))
            
            Text("오늘도 지구를 위해 함께 걸어요!")
                .font(.Jamsil.light.font(size: 14))
            
            if WCSessionManager.isCountDownPresented {
                Text("오늘도 지구를 위해 함께 걸어요!")
                    .font(.Jamsil.light.font(size: 14))
            }
        }
    }
}

struct WatchMainView_Previews: PreviewProvider {
    static var previews: some View {
        WatchMainView()
    }
}
