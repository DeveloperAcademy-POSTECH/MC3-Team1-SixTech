//
//  ImageMerger.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/20.
//

import SwiftUI

struct ImageMerger {
func merge(_ bottomImageName: String, with topImageName: String) -> UIImage {
    let bottomImage = UIImage(named: bottomImageName)
    let topImage = UIImage(named: topImageName)

    let size = CGSize(width: 300, height: 300)
    UIGraphicsBeginImageContext(size)

    let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    bottomImage!.draw(in: areaSize)

    topImage!.draw(in: areaSize, blendMode: .normal, alpha: 1)

    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return newImage
}}
