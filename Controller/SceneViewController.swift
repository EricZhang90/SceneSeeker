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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: Photo process
extension SceneViewController: UIImagePickerControllerDelegate {
    @IBAction func getPhoto(_ sender: Any) {
        
        let photoPickerVC = UIImagePickerController()
        photoPickerVC.delegate = self
        photoPickerVC.allowsEditing = false
        photoPickerVC.modalPresentationStyle = .fullScreen
        
        let alertController = UIAlertController(title: "Choose a photo from", message: "", preferredStyle: .alert)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
            
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                
                let error = "Camera is not available"
                
                UIAlertController.present(in: self, message: error, completion: nil)
                
                return
            }
            
            photoPickerVC.sourceType = .camera
            photoPickerVC.cameraCaptureMode = .photo
            
            self.present(photoPickerVC, animated: true, completion: nil)
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (_) in
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
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(Photo(image: image))
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension SceneViewController: UINavigationControllerDelegate {
}

