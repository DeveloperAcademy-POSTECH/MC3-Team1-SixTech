//
//  ImageURLExtension.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/25.
//

import Foundation
import SwiftUI

func loadImageFromURL(imageURL: URL) -> UIImage {
    guard let imageData = try? Data(contentsOf: imageURL),
          let uiImage = UIImage(data: imageData) else {
        return UIImage()
    }
    return uiImage
}

struct ImageFromURL_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
           Image(uiImage: loadImageFromURL(imageURL: UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "")!)) 
        }
    }
}
