//
//  File.swift
//  SixTech
//
//  Created by 주환 on 2023/07/15.
//

import Foundation
import GameKit

enum PlayerAuthState: String {
    case authenticating = "Logging in to Game Center..."
    case unauthenticated = "Please sign in to Game Center to play."
    case authenticated = ""
    
    case error = "There was an error, logging into Game Center."
    case restricted = "You're not allowed to play multiplayer games!"
}

class MatchManager: NSObject, ObservableObject {
    
    static let shared = MatchManager()
    
    private var matchRequest: GKMatchRequest = GKMatchRequest()
    private var matchmakingMode: GKMatchmakingMode = .default
    private var matchmaker: GKMatchmaker?
    
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var authenticationState = PlayerAuthState.authenticating
    @Published var lastData = ""
    @Published var groupNumber = ""
    @Published var otherPlayer: [GKPlayer]?
    @Published var otherPlayerInfo: [UserInfo]? = []
    
    var maxPlayer: Int = 2
    var localPlayerInfo: UserInfo?
    var match: GKMatch?
    var localPlayer = GKLocalPlayer.local
    private var playerUUIDKey = UUID().uuidString

    private var rootViewController: UIViewController? {
        let windowsence = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowsence?.windows.first?.rootViewController
    }
    
    func generateRandomPlayCode() {
        let randomNumber = Int.random(in: 0...9999)
        groupNumber = String(format: "%04d", randomNumber)
    }
    
    func startMatchmaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = maxPlayer
        request.playerGroup = Int(groupNumber)!
        matchRequest = request
        
        matchmaker = GKMatchmaker.shared()
        matchmaker?.findMatch(for: matchRequest, withCompletionHandler: { [weak self] (match, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else if let match = match {
                print("매치를 찾음 !")
                self?.startGame(newMatch: match)
            }
        })
    }
    
    func cancelMatchmaking() {
        matchmaker?.cancel()
        otherPlayer = nil
        print("매치 취소!")
    }
    
    func authenticateUser() {
        print("유저 인증 시작")
        GKLocalPlayer.local.authenticateHandler = { [self] viewc, error in
            if let viewContorller = viewc {
                rootViewController?.present(viewContorller, animated: true)
                return
            }
            if let error = error {
                authenticationState = .error
                print(error.localizedDescription)
                return
            }
            if localPlayer.isAuthenticated {
                if localPlayer.isMultiplayerGamingRestricted {
                    authenticationState = .restricted
                } else {
                    authenticationState = .authenticated
                }
            } else {
                authenticationState = .unauthenticated
            }
        }
    }
    
    func startGame(newMatch: GKMatch) {
        newMatch.delegate = self
        match = newMatch
        
        if let players = match?.players {
            otherPlayer = players
            inGame = true
//            sendString("began: \(playerUUIDKey)")
        } else {
            print("player info nothing..")
        }
//        게임로직 시작 하면됨..
    }
    
    func receivedString(_ message: String) {
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        let parameter = String(messageSplit.last ?? "")
        
        switch messagePrefix {
        case "began":
            if playerUUIDKey == parameter {
                playerUUIDKey = UUID().uuidString
                sendString("began:\(playerUUIDKey)")
                break
            } else {
//                DispatchQueue.main.async {
//                    self.lastData = parameter
//                }
            }
//            inGame = true // 게임중이라는 거 여기다 다표시해주기
        default:
            break
        }
    }
    
    func receivedData(_ imageUrl: URL) {
//        otherPlayerInfo
    }

}

// MARK: GKMatchDelegate
extension MatchManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if let content = decodeUserInfo(data) {
            DispatchQueue.main.async { [self] in
                if !(otherPlayerInfo?.contains(where: { $0.uuid == content.uuid }))! {
                    otherPlayerInfo?.append(content)
                }
            }
        }
//        if content.starts(with: "strData") {
//            let message = content.replacing("strData:", with: "")
//            receivedString(message)
//        } else {
//            if let imgdata = URL(dataRepresentation: data, relativeTo: nil) {
//                // Data를 URL로 변환 성공 시 처리
//                // 변환된 URL을 이용하여 다른 작업을 수행할 수 있습니다.
//                self.otherPlayerInfo?.first?.profileImageURL = imgdata
//            } else {
//                // Data를 URL로 변환 실패 시 처리
//                print("Data를 URL로 변환하는데 실패하였습니다.")
//            }
//
//            // 만약 깨진 데이터 받아서 이상해지면.... -> lastData로 처리해주는 로직대충 만들기
//        }
    }
    
    func sendString(_ message: String) {
        guard let encoded = "strData:\(message)".data(using: .utf8) else { return }
        sendData(encoded, mode: .reliable)
    }
    
    func sendImageUrl() {
        guard let info = localPlayerInfo else { return }
        if let data = encodeUserInfo(info) {
            sendData(data, mode: .reliable)
        }
    }
    
    func sendMissionImage() {
        if let info = localPlayerInfo {
            if let myphoto = localPlayerInfo?.myMissionPhoto {
                if let data = encodeUserInfo(info) {
                    sendData(data, mode: .reliable)
                }
            }
        }
    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        do {
            try match?.sendData(toAllPlayers: data, with: mode)
        } catch {
            print("데이터 보내기 에러 = \(error.localizedDescription)")
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
//        guard let user = localPlayerInfo else { return }
        switch state {
        case .connected:
            DispatchQueue.main.async {
//                self.otherPlayer?.append(player)
//                self.sendString("began: \(user.name)")
                self.sendImageUrl()
            }
        case .disconnected:
            print("플레이어\(player.displayName)의 연결이 끊김")
        case .unknown:
            // 연결 상태를 알 수 없을 때 처리
            break
        @unknown default:
            break
        }
            
    }
}
