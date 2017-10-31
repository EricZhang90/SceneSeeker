//
//  UIImage+Data.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-30.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class UIImageManger {
    
}

// MARK: local repository
extension UIImageManger {
    
    static func saveImageInFileSystem(image: UIImage) -> String {

        let fileURL = URL.getFilePath(fileName: UUID().uuidString)
        
        let data = UIImagePNGRepresentation(image)!
        
        try! data.write(to: fileURL)
        
        return fileURL.path
    }
    
    static func deleteImageFromFileSystem(filePath: String) {
        
        try! FileManager.default.removeItem(atPath: filePath)
    }
}

// MARK: Networking handler(Alamofire)

extension UIImageManger {
    func save() {
        
    }
}



