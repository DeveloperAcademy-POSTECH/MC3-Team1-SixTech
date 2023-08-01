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
	@EnvironmentObject var ploggingManager: PloggingManager

    var body: some View {
        ZStack {
            Color.background2Color.ignoresSafeArea()
            
            VStack {
                Text("플로깅을 시작해요")
                    .font(.Jamsil.bold.font(size: 24))
					.padding(.bottom)
                Text("모든 플로깅을 응원해요.\n함께 달려봐요!")
                    .multilineTextAlignment(.center)
                    .font(.Jamsil.light.font(size: 20))
                Spacer()
            }
            .padding(.top, 50)
            
            Text("\(timeRemaining)")
                .foregroundColor(.fontColor)
                .font(.Jamsil.extraBold.font(size: 150))
                .animation(.easeInOut(duration: 0.5))
                .onReceive(timer) { _ in
                    if self.timeRemaining > 1 {
                        self.timeRemaining -= 1
                    } else {
                        timer.upstream.connect().cancel()
                        timerFinished = true
                    }
                }
            NavigationLink("", destination: MapView(), isActive: $timerFinished)
				.onChange(of: timerFinished) { _ in
					ploggingManager.startPedometer()
				}
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
