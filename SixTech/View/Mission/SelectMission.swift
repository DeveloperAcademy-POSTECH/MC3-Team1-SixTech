//
//  MissionViewModel.swift
//  SixTech
//
//  Created by 장수민 on 2023/07/29.
//

import Foundation
import SwiftUI

 class SelectMission: ObservableObject {

     @Published var selectedMission: String = ""

     let missions: [String] = [ "길고양이 사진 찍기", "길가에 핀 꽃 사진 찍기", "하늘 사진 찍기", " 팀원 한명 이상과 신발 사진 찍기", "부피가 큰 쓰레기 사진 찍기", "파란색 병뚜껑 사진 찍기", "희귀한 쓰레기 사진 찍기", "플로깅하는 팀원의 사진찍기", "다 모은 쓰레기봉투 사진찍기", "원하는 사진 찍기"]

     init() {
            // 초기화 시점에 미션을 랜덤으로 선택
            selectedMission = getRandomMission()
        }

     func getRandomMission() -> String {
         // 랜덤으로 인덱스 생성
         let randomIndex = Int.random(in: 0..<missions.count)
         // 해당 인덱스의 미션 반환
         return missions[randomIndex]
     }
 }
