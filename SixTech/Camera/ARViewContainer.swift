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
        let tapRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapRecognizer)
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
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = gesture.view as? ARSCNView else { return }
            let touchLocation = gesture.location(in: arView)
            let hitTestResults = arView.hitTest(touchLocation, types: .estimatedHorizontalPlane)
            guard let hitTestResult = hitTestResults.first else { return }
            let transform = hitTestResult.worldTransform
            let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            addARObject(at: position, to: arView)
        }
        
        func addARObject(at position: SCNVector3, to arView: ARSCNView) {
            let yourSCNFile = SCNScene(named: "stone.scn")
            guard let scnNode = yourSCNFile?.rootNode else { return }
            scnNode.position = position
            scnNode.scale = SCNVector3(1, 1, 1)
            arView.scene.rootNode.addChildNode(scnNode)
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            if let faceAnchor = anchor as? ARFaceAnchor, parent.useFrontCamera {
                let yourSCNFile = SCNScene(named: "stone.scn")
                let scnNode = yourSCNFile?.rootNode
                node.addChildNode(scnNode!)
            }
        }
    }
}
