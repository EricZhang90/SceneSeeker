//
//  Scene.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-30.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import RealmSwift

class Scene: Object {
    
    convenience init(identifier: String, confidence: Double) {
        self.init()
        self.identifier = identifier
        self.confidence = confidence
    }
    
    
    // MARK: Persisted properties
    @objc dynamic var identifier: String!
    @objc dynamic var confidence = 0.0
    let similarScenePaths = List<String>()
}

