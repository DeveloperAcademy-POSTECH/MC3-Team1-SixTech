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

class MatchManager: NSObject, ObservableObject,
                    CustomMatchmakerViewControllerDelegate {
    func customMatchmakerViewController(_ viewController: CustomMatchmakerViewController,
                                        didFind match: GKMatch) {
        viewController.dismiss(animated: true)
        startGame(newMatch: match)
        print("match successful")
        match.delegate = self
    }
    
    func customMatchmakerViewController(_ viewController: CustomMatchmakerViewController,
                                        didFailWithError error: Error) {
        print("error in Matching")
        viewController.dismiss(animated: true)
    }
    
    func customMatchmakerViewControllerWasCancelled(_ viewController: CustomMatchmakerViewController) {
        print("Cencle in Matching")
        viewController.dismiss(animated: true)
    }
    
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var authenticationState = PlayerAuthState.authenticating
    @Published var lastData = ""
//    @Published var currentlyDrawing = false
    var match: GKMatch?
    var otherPlayer: [GKPlayer]?
    var localPlayer = GKLocalPlayer.local
    
    var playerUUIDKey = UUID().uuidString
    
    var rootViewController: UIViewController? {
        let windowsence = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowsence?.windows.first?.rootViewController
    }
    
    func authenticateUser() {
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
    
    func startMatchMaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 8
        request.playerGroup = 9292
        
        let matchmakingVC = CustomMatchmakerViewController(matchRequest: request, matchmakingMode: .default)
        matchmakingVC.delegate = self
        rootViewController?.present(matchmakingVC, animated: true)
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
    }
}
