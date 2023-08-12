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
enum GameSessionState {
    case idle
    case matchmaking
    case inGame
}

final class MatchManager: NSObject, ObservableObject {
    static let shared = MatchManager()
    
    private var matchRequest: GKMatchRequest = GKMatchRequest()
    private var matchmakingMode: GKMatchmakingMode = .default
    private var matchmaker: GKMatchmaker?
    
    @Published var gameState: GameSessionState = .idle
    @Published var isHost = false
    @Published var authenticationState = PlayerAuthState.authenticating
//    @Published var lastData = ""
    @Published var groupNumber = ""
    @Published var otherPlayer: [GKPlayer]?
    @Published var otherPlayerInfo: [UserInfo]? = []
    
    var maxPlayer: Int = 10
    var localPlayerInfo: UserInfo?
    var hostPlayer: String?
    var match: GKMatch?
    var localPlayer = GKLocalPlayer.local
    private var playerUUIDKey = UUID().uuidString

    private var rootViewController: UIViewController? {
        let windowsence = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowsence?.windows.first?.rootViewController
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
        
        gameState = .matchmaking
        
        matchmaker = GKMatchmaker.shared()
        matchmaker?.findMatch(for: matchRequest, withCompletionHandler: { [weak self] (match, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else if let match = match {
                self?.startGame(newMatch: match)
            }
        })
    }
    
    func cancelMatchmaking() {
        matchmaker?.cancel()
        otherPlayer = nil
        otherPlayerInfo = nil
        print("매치 취소!")
    }
    
    func startGame(newMatch: GKMatch) {
        newMatch.delegate = self
        match = newMatch
        
        if let match = match, match.players.isEmpty {
            otherPlayer = newMatch.players
//            inGame = true
        } else {
            print("player info nothing..")
        }
    }

}

// MARK: GKMatchDelegate
extension MatchManager: GKMatchDelegate {
    // Receive..
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        print(#function)
        switch gameState {
        case .matchmaking:
            let content = String(decoding: data, as: UTF8.self)
            if content.starts(with: "strData") {
                let message = content.replacing("strData:", with: "")
                receivedString(message)
            }
            gameState = .inGame
        case .inGame:
            if let content = decodeUserInfo(data) {
                DispatchQueue.main.async { [self] in
                    if let index = otherPlayerInfo?.firstIndex(where: { $0.uuid == content.uuid }) {
                        // If an element with the same uuid exists, replace it
                        otherPlayerInfo?[index] = content
                    } else {
                        // If the uuid doesn't exist, append the new element
                        otherPlayerInfo?.append(content)
                    }
                }
            } else {
                sendUserInfo()
                }
        case .idle:
            print("아직 게임 매칭상태도아님.")
        }
        
    }
    
    private func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) async {
        print(#function)
//        guard let user = localPlayerInfo else { return }
        switch state {
        case .connected:
            print("DEBUG: localplayer = \(localPlayer.displayName), otherplayer = \(player.displayName)")
            if isHost {
                hostPlayer = localPlayer.displayName
                guard let host = hostPlayer else { print("ishost, host optional and nil !")
                    return }
                sendString(host)
            }
//            DispatchQueue.main.async {
//                guard let host = self.hostPlayer else { return }
//                self.sendString("began: \(host.gamePlayerID)")
//                self.otherPlayer?.append(player)
//                self.sendString("began: \(user.name)")
//                self.sendUserInfo()
//            }
        case .disconnected:
            print("플레이어\(player.displayName)의 연결이 끊김")
        case .unknown:
            print("\(player.displayName)의 연결상태 모름")
        @unknown default:
            break
        }
            
    }
}
