//
//  ContentView.swift
//  SixTech
//
//  Created by 이재원 on 2023/07/09.
//

import SwiftUI

struct ContentView: View {
    
    let num65: Int = 3
    private var isConditionValid: Bool {
           false
    }
    var body: some View {
        VStack {
            Button("Test Test") {
                 print("SixTech")
             }.buttonStyle(DefaultButton(isdisable: isConditionValid))
             .disabled(isConditionValid)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
