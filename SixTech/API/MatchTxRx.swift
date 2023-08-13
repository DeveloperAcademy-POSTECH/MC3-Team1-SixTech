//
//  MatchIO.swift
//  SixTech
//
//  Created by 주환 on 2023/08/12.
//

import GameKit
import Foundation

// MARK: send / receive
extension MatchManager {
    
    func receivedString(_ message: String) {
        print(#function)
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
//        let parameter = String(messageSplit.last ?? "")
        switch messagePrefix {
        case "began":
            print("began????")
        default:
            hostPlayer = match?.players.first(where: { $0.displayName == message })?.displayName
            sendUserInfo()
            DispatchQueue.main.async {
                self.gameState = .inGame                
            }
        }
    }
    
    func sendString(_ message: String) {
        print(#function)
        print("DEBUG: send string = \(message)")
        guard let encoded = "strData:\(message)".data(using: .utf8) else { return }
        sendData(encoded, mode: .reliable)
    }
    
    func sendUserInfo() {
        guard let info = localPlayerInfo else { return }
        if isHost {
            guard var infoarr = otherPlayerInfo else { return }
            infoarr.insert(info, at: 0)
            if let data = encodeUserInfoArray(infoarr) {
                sendData(data, mode: .reliable)
            }
            
        } else {
            //        info.myMissionPhoto
            if let data = encodeUserInfo(info) {
                sendData(data, mode: .reliable)
            }
        }
    }
    
//    func sendMissionImage() {
//        sendUserInfo()
//    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        if isHost {
            do {
                print("호스트 보냄")
                try match?.sendData(toAllPlayers: data, with: mode)
            } catch {
                print("데이터 보내기 에러 = \(error.localizedDescription)")
            }
        } else {
            print("비호스트가 보냄")
            guard let host = match?.players.first(where: { $0.displayName == hostPlayer }) else { return }
            do {
                try match?.send(data, to: [host], dataMode: mode)
            } catch {
                print("데이터 보내기 에러 = \(error.localizedDescription)")
            }
        }
        
    }
    
}
