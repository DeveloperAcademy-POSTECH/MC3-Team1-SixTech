//
//  WatchMainView.swift
//  PlogWatch Watch App
//
//  Created by 이재원 on 2023/08/02.
//

import SwiftUI

struct WatchMainView: View {
    var body: some View {
        VStack {
            Text("같이줍깅")
                .font(.Jamsil.bold.font(size: 18))
            
            Text("오늘도 지구를 위해 함께 걸어요!")
                .font(.Jamsil.light.font(size: 14))
        }
    }
}

struct WatchMainView_Previews: PreviewProvider {
    static var previews: some View {
        WatchMainView()
    }
}
