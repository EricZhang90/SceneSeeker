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
    
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
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
        
        cameraBtn.isHidden = true
        cancelBtn.isHidden = true
        
        captureSession.stopRunning()
    }
    
    
    @IBAction func cameraDidCancel() {
        
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Process Image
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard error == nil else {
            alert(msg: "Camera is not available")
            return
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

