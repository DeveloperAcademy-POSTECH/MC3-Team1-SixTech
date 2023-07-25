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
    
    private var matchRequest: GKMatchRequest = GKMatchRequest()
    private var matchmakingMode: GKMatchmakingMode = .default
    private var matchmaker: GKMatchmaker?
    
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var authenticationState = PlayerAuthState.authenticating
    @Published var lastData = ""
    @Published var groupNumber = ""
    @Published var otherPlayer: [GKPlayer]?

    var match: GKMatch?
    var localPlayer = GKLocalPlayer.local
    
    var playerUUIDKey = UUID().uuidString
    var rootViewController: UIViewController? {
        let windowsence = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowsence?.windows.first?.rootViewController
    }
    
    func generateRandomPlayCode() {
        let randomNumber = Int.random(in: 0...9999)
        groupNumber = String(format: "%04d", randomNumber)
    }
    
    func startMatchmaking(_ maxPlayer: Int?) {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = maxPlayer ?? 2
        request.playerGroup = Int(groupNumber)!
        matchRequest = request
        
        matchmaker = GKMatchmaker.shared()
        matchmaker?.findMatch(for: matchRequest, withCompletionHandler: { [weak self] (match, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else if let match = match {
                print("매치를 찾음 !")
                self?.startGame(newMatch: match)
                
                match.delegate = self
            }
        })
    }
    
    func cancelMatchmaking() {
        matchmaker?.cancel()
        print("매치 취소 했엉!")
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
        match = newMatch
        match?.delegate = self
        if let players = match?.players {
            otherPlayer = players
            print("\(players.first?.displayName ?? "player name error")")
            inGame = true
        } else {
            print("player info nothing..")
        }
        sendString("began: \(playerUUIDKey)")
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
            }
//            inGame = true // 게임중이라는 거 여기다 다표시해주기
        default:
            break
        }
    }
}

// MARK: GKMatchDelegate
extension MatchManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let content = String(decoding: data, as: UTF8.self)
        
        if content.starts(with: "strData") {
//            let message = content.replacing("strData:", with: "")
//            reci
        } else {
//            do {
////                lastData 데이터 가져오기
//            } catch {
//                print("error")
//            }
        }
    }
    
    func sendString(_ message: String) {
        guard let encoded = "strData:\(message)".data(using: .utf8) else { return }
        sendData(encoded, mode: .reliable)
    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        do {
            try match?.sendData(toAllPlayers: data, with: mode)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        print(" \(state) is connection changed..")
        if state.rawValue == 1 {
            DispatchQueue.main.async {
                self.otherPlayer?.append(player)
            }
        }
    }
}
