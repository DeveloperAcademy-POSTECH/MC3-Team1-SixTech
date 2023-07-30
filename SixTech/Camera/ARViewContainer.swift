//
//  ARViewContainer.swift
//  earth2
//
//  Created by 신정연 on 2023/07/27.
//
import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var useFrontCamera: Bool
    @ObservedObject var cameraModel: CameraModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        arView.session.delegate = context.coordinator
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        let configuration = useFrontCamera ? ARFaceTrackingConfiguration() : ARWorldTrackingConfiguration()
        uiView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            // Check if the added anchor is an ARFaceAnchor when using ARFaceTrackingConfiguration
            if let faceAnchor = anchor as? ARFaceAnchor, parent.useFrontCamera {
                // Load your SCN file and add it to the node
                let yourSCNFile = SCNScene(named: "sneaker_pegasustrail.scn")
                let scnNode = yourSCNFile?.rootNode
                node.addChildNode(scnNode!)
            } else {
                // Load your SCN file and add it to the node
                let yourSCNFile = SCNScene(named: "sneaker_pegasustrail.scn")
                let scnNode = yourSCNFile?.rootNode
                node.addChildNode(scnNode!)
            }
        }
    }
}
