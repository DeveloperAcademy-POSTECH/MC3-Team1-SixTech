//
//  ARViewContainer.swift
//  earth2
//
//  Created by 신정연 on 2023/07/27.
//

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let anchor = try! Earth.load_3d()
        arView.scene.anchors.append(anchor)
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
