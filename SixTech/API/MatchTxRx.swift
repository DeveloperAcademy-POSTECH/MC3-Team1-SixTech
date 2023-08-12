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
//            inGame = true // 게임중이라는 거 여기다 다표시해주기
        default:
            hostPlayer = match?.players.first(where: { $0.displayName == message })?.displayName
            sendUserInfo()
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
//        info.myMissionPhoto
        if let data = encodeUserInfo(info) {
            sendData(data, mode: .reliable)
        }
    }
    
    func sendMissionImage() {
        if let info = localPlayerInfo, !isHost {
            if  info.myMissionPhoto != nil {
                if let data = encodeUserInfo(info) {
                    sendData(data, mode: .reliable)
                    print("DEBUG: data send sucessfully")
                }
            }
        }
    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        if isHost {
            do {
                try match?.sendData(toAllPlayers: data, with: mode)
            } catch {
                print("데이터 보내기 에러 = \(error.localizedDescription)")
            }
        } else {
            guard let host = match?.players.first(where: { $0.displayName == hostPlayer }) else { return }
            do {
                try match?.send(data, to: [host], dataMode: mode)
            } catch {
                print("데이터 보내기 에러 = \(error.localizedDescription)")
            }
        }
        
    }
    
}
