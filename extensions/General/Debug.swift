//
//  DebugTool.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-31.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import Foundation

class Debug {

    class func checkFilePermission(_ path: String) {
        let fileManager = FileManager.default
        
        print("Checking file path: \(path)")
        let isExisting = fileManager.fileExists(atPath: path)
        print("exists: \(isExisting)")
        
        if isExisting {
            let isReadable = fileManager.isReadableFile(atPath: path)
            print("is readable: \(isReadable)")
        }
    }
}

