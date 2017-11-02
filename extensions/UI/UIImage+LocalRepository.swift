//
//  UIImage+Data.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-30.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import Alamofire

fileprivate let imagesLocalPath = URL.createFilePath(fileName: "images").path + "/"

// MARK: Local repository
extension UIImage {
    
    // loads image from documents folder by uuid
    convenience init(uuid: String) {
        self.init(contentsOfFile: imagesLocalPath + uuid)!
    }
    
    // return uuid
    func saveInFileSystem() -> String {
        
        let uuid = UUID().uuidString
        
        let imagePath = imagesLocalPath + uuid
        
        let data = UIImagePNGRepresentation(self)!
        
        let imageURL = URL(fileURLWithPath: imagePath)
        
        try! data.write(to: imageURL)
        
        return uuid
    }
    
    func deleteImageFromFileSystem(by uuid: String) {
        
        let imagePath = imagesLocalPath + uuid
        
        try? FileManager.default.removeItem(atPath: imagePath)
    }
}






