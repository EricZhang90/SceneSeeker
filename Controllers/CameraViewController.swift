//
//  CameraViewController.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-02.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift


class CameraViewController: UIViewController {
    
    var cameraBtn: UIButton!
    var cancelBtn: UIButton!
    
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        captureSession.stopRunning()
        super.dismiss(animated: flag, completion: completion)
    }
}


// MARK: - Camera setup
extension CameraViewController {
    
    func setupCamera() {
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            alert(msg: "Back camera is not available")
            return
        }
        
        let input = try! AVCaptureDeviceInput(device: backCamera)
        
        if captureSession!.canAddInput(input) {
            
            captureSession!.addInput(input)
            
            photoOutput = AVCapturePhotoOutput()
            
            if captureSession!.canAddOutput(photoOutput!) {
                
                captureSession!.addOutput(photoOutput!)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                previewLayer.frame = view.bounds
                previewLayer.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
                
                view.layer.insertSublayer(previewLayer, at: 0)
                
                captureSession.startRunning()
                captureSession.commitConfiguration()
            }
        }
        
    }

    
    @IBAction func cameraDidTaped() {

        let setting = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        photoOutput.capturePhoto(with: setting, delegate: self)
    }
    
    
    @IBAction func cameraDidCancel() {
        
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Process Image
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        let imageData = photo.fileDataRepresentation()
        
        let image = UIImage(data: imageData!, scale: 1.0)
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "photoNotification"),
            object: nil,
            userInfo: ["photo": image as Any])
        
        dismiss(animated: true, completion: nil)
    }
    
}

