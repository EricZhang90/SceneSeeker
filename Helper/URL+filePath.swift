//
//  URL+filePath.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-30.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import Foundation

extension URL {
    
    // returns an absolute URL to the desired file in documents folder
    static func getFilePath(fileName: String) -> URL {
        
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to find a document directory")
        }
        
        return documentsURL.appendingPathComponent(fileName)
    }
}
