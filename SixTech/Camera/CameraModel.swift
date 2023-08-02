//
//  CameraModel.swift
//  earth2
//
//  Created by 신정연 on 2023/07/27.
//
import SwiftUI
import AVFoundation

class CameraModel: NSObject, ObservableObject {
    
    private var captureSession: AVCaptureSession?
    private var frontCamera: AVCaptureDevice?
    private var rearCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    private var photoOutput: AVCapturePhotoOutput?
    
    @Published var isUsingFrontCamera = false
    @Published var isFlashOn = false
    
    override init() {
        super.init()
        setupCaptureSession()
    }
    
    // 카메라 세션 설정
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        // 카메라 장치 찾기
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .unspecified)
        for device in discoverySession.devices {
            if device.position == .front {
                frontCamera = device
            } else if device.position == .back {
                rearCamera = device
            }
        }
        
        // 카메라 기본 설정
        currentCamera = rearCamera
        guard let camera = currentCamera else { return }
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession?.addInput(input)
            photoOutput = AVCapturePhotoOutput()
            if let output = photoOutput, captureSession?.canAddOutput(output) == true {
                captureSession?.addOutput(output)
            }
        } catch {
            print("Error setting device input: \(error.localizedDescription)")
        }
    }
    
    // 전/후면 카메라 전환
    func toggleCamera() {
        print("toggle camera")
        captureSession?.beginConfiguration()
        if isUsingFrontCamera {
            switchToRearCamera()
        } else {
            switchToFrontCamera()
        }
        captureSession?.commitConfiguration()
        isUsingFrontCamera.toggle()
    }
    
    private func switchToFrontCamera() {
        guard let frontCamera = frontCamera else { return }
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            captureSession?.removeInput((captureSession?.inputs.first!)!)
            captureSession?.addInput(input)
            currentCamera = frontCamera
        } catch {
            print("Error switching to front camera: \(error.localizedDescription)")
        }
    }
    
    private func switchToRearCamera() {
        guard let rearCamera = rearCamera else { return }
        do {
            let input = try AVCaptureDeviceInput(device: rearCamera)
            captureSession?.removeInput((captureSession?.inputs.first!)!)
            captureSession?.addInput(input)
            currentCamera = rearCamera
        } catch {
            print("Error switching to rear camera: \(error.localizedDescription)")
        }
    }
    
    // 플래시 제어
    func toggleFlash() {
        if let device = currentCamera, device.hasTorch {
            do {
                try device.lockForConfiguration()
                if isFlashOn {
                    device.torchMode = .off
                } else {
                    device.torchMode = .on
                }
                device.unlockForConfiguration()
                isFlashOn.toggle()
            } catch {
                print("Error toggling flash: \(error.localizedDescription)")
            }
        }
    }
    
    // 사진 찍기
    func takePhoto() {
        print("take photo")
        let settings = AVCapturePhotoSettings()
        if isFlashOn, let device = currentCamera, device.hasTorch {
            settings.flashMode = .on
        } else {
            settings.flashMode = .off
        }
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
}

// AVCapturePhotoCaptureDelegate 채택
extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            saveImageToAlbum(imageData: imageData)
        }
    }
    func saveImageToAlbum(imageData: Data) {
        print("saveImageToAlbum2")
        guard let image = UIImage(data: imageData) else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
