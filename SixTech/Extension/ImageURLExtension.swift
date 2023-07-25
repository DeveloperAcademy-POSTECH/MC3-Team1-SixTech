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
