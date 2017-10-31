//
//  ScenePhotoView.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-27.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class ScenePhotoView: UIView {

    private var _image: UIImage?
    
    // process image(reduce/increase size) in global thread and update UIView's context in main thread
    var image: UIImage? {
        set {
            self.backgroundColor = UIColor.black
            _image = newValue
            layer.contents = nil

            guard let newImage = newValue else {
                return
            }

            DispatchQueue.global(qos: .userInitiated).async {
                let decodedImage = self.decodedImage(newImage)
                DispatchQueue.main.async {
                    self.layer.contents = decodedImage
                }
            }
        }
        get {
            return _image
        }
        
        
    }
    
    func decodedImage(_ image: UIImage) -> CGImage? {
        guard let newImage = image.cgImage else {
            return nil
        }
        
        let width = newImage.width * 8 / 10
        let height = newImage.height * 8 / 10
        let size = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage?.cgImage
    }

}









