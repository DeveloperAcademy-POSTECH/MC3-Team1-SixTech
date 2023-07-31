//
//  CountDownView.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/28.
//

import SwiftUI

struct CountDownView: View {
    @State var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timerFinished = false

    var body: some View {
        ZStack {
            Color.background2Color.ignoresSafeArea()
            
            VStack {
                Text("플로깅을 시작해요")
                    .font(.Jamsil.bold.font(size: 24))
                Text("모든 플로깅을 응원해요.\n함께 달려봐요!")
                    .multilineTextAlignment(.center)
                    .font(.Jamsil.light.font(size: 20))
                Spacer()
            }
            .padding(.top, 50)
            
            Text("\(timeRemaining)")
                .foregroundColor(.countDownColor)
                .font(.Jamsil.extraBold.font(size: 150))
                .animation(.easeInOut(duration: 0.5))
                .onReceive(timer) { _ in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    } else {
                        timer.upstream.connect().cancel()
                        timerFinished = true
                    }
                }
            NavigationLink("", destination: Text("하핫 코딩은 즐거워"), isActive: $timerFinished)
        }
    }
}

struct CountDownView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CountDownView()
        }
    }
}
