//
//  ViewController.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-27.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import RealmSwift

class SceneViewController: UIViewController {

    @IBOutlet weak var photoView: MainPhotoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPhotoReceiver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: Photo process
extension SceneViewController: UIImagePickerControllerDelegate {
    @IBAction func getPhoto(_ sender: Any) {
        
        
        
        let alertController = UIAlertController(title: "Choose a photo from", message: "", preferredStyle: .alert)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
            
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                
                let error = "Camera is not available"
                
                self.alert(msg: error)
                
                return
            }
            
            let cameraVC = self.storyboard!.instantiateViewController(withIdentifier: "cameraViewController")
            
            self.present(cameraVC, animated: true, completion: nil)
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            
            let photoPickerVC = UIImagePickerController()
            photoPickerVC.delegate = self
            photoPickerVC.allowsEditing = false
            photoPickerVC.modalPresentationStyle = .fullScreen
            
            photoPickerVC.sourceType = .photoLibrary
            
            self.present(photoPickerVC, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("couldn't load image from Photos")
        }
        
        processImage(image)
    }
    
    func processImage(_ image: UIImage) {
        
        let photo = Photo(image: image)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(photo)
        }
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "analysisTableViewController") as! AnalysisTableViewController
        nextVC.photo = photo
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

// MARK: - UINavigationControllerDelegate
extension SceneViewController: UINavigationControllerDelegate {
}

// MARK: - Receive photo
extension SceneViewController {
    
    func addPhotoReceiver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(photoDidReceived),
            name: Notification.Name(rawValue: "photoNotification"),
            object: nil)
    }
    
    @objc func photoDidReceived(notification:NSNotification) {
        
        let userInfo = notification.userInfo as! Dictionary<String,UIImage>
        
        let image = userInfo["photo"]
        
        processImage(image!)
    }
}
