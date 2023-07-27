//
//  TestView.swift
//  SixTech
//
//  Created by 주환 on 2023/07/13.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var matchManager: MatchManager
    
    var body: some View {
        VStack {
            if matchManager.isGameOver {
                Text("Game Over View !")
            } else if matchManager.inGame {
                Text("in Game View !")
            } else {
                VStack {
                    Text(" Matching View !")
                    Button {

                    } label: {
                        Text("Maching Start !")
                    }

                }
            }
        }.onAppear {
            matchManager.authenticateUser()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
