//
//  Tags.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-08.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import RealmSwift

class Tag: Object {
    
    convenience init(identifier: String, confidence: Double) {
        self.init()
        self.identifier = identifier
        self.confidence = confidence
    }
    
    
    // MARK: Persisted properties
    @objc dynamic var identifier = ""
    @objc dynamic var confidence = 0.0
}
