//
//  ImageProcessDelegate.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-08.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

protocol ImageProcessor:  ErrorHandler{
    
    // MARK: optional methods
    func processUploadProgress(_ percent: Float)
    
    // MARK: must be implemented
    func processTags(_ tags: [Tag])
    func processCategories(_ categories: [Scene], kind: SceneDetector.Kind)
}

extension ImageProcessor {
    func processUpload(_ percent: Float) {
        
    }
}
