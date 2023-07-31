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
    @Binding var currentIndex: Int
    
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
        if useFrontCamera {
            let configuration = ARFaceTrackingConfiguration()
            uiView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        } else {
            let configuration = ARWorldTrackingConfiguration()
            uiView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        var parent: ARViewContainer
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        var filterIndex: Int {
            parent.currentIndex % 3
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
            if filterIndex == 2 {
                let yourSCNFile = SCNScene(named: "stone.scn")
                guard let scnNode = yourSCNFile?.rootNode else { return }
                
                scnNode.position = position
                scnNode.scale = SCNVector3(1, 1, 1)
                arView.scene.rootNode.addChildNode(scnNode)
            }
        }
        
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            guard let faceAnchor = anchor as? ARFaceAnchor, parent.useFrontCamera else {
                return nil
            }
            if filterIndex == 2 {
                let yourSCNFile = SCNScene(named: "stone.scn")
                guard let scnNode = yourSCNFile?.rootNode else { return nil }
                scnNode.position = SCNVector3(faceAnchor.leftEyeTransform.columns.3.x, faceAnchor.leftEyeTransform.columns.3.y, faceAnchor.leftEyeTransform.columns.3.z)
                scnNode.scale = SCNVector3(0.1, 0.1, 0.1)
                return scnNode
            } else {
                return nil
            }
        }
    }
}
