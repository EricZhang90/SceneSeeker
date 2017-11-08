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


class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBAction func takePhoto(_ sender: Any) {
    }
    
    var cameraBtn: UIButton!
    var cancelBtn: UIButton!
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        let imageData = photo.fileDataRepresentation()

//        let cgImage
        let image = UIImage(data: imageData!, scale: 1.0)
        
//        let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
        let photo = Photo(image: image!)
        let realm = try! Realm()
        try! realm.write {
            realm.add(photo)
        }
        captureSession?.stopRunning()
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "analytisViewController") as! AnalytisViewController
        nextVC.photo = photo
        present(nextVC, animated: true, completion: nil)
        //navigationController?.pushViewController(nextVC, animated: true)
    }
  
    
    // MARK: Local Variables
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?

    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        
        //view.backgroundColor = UIColor.white
        
        // setupButtons()
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraDidTaped))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSession.Preset.photo
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession!.canAddOutput(stillImageOutput!) {
                captureSession!.addOutput(stillImageOutput!)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                previewLayer?.frame = view.bounds
                previewLayer!.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
                view.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
                captureSession?.commitConfiguration()
            }
        }
    }
    
    func setupButtons() {
        
        cameraBtn = UIButton()
        
        cameraBtn.addTarget(self, action: #selector(cameraDidTaped), for: .touchUpInside)
        
        cameraBtn.setBackgroundImage(UIImage(named: "camera_circle"), for: .normal)
        
        cameraBtn.clipsToBounds = true
        
        view.addSubview(cameraBtn)
        
        cameraBtn.translatesAutoresizingMaskIntoConstraints = false
        
        cameraBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        cameraBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100).isActive = true
        
        cameraBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        cameraBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func cameraDidTaped() {
        let setting = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        stillImageOutput?.capturePhoto(with: setting, delegate: self)
        
    }
}
