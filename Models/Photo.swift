//
//  Photo.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-30.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import RealmSwift

class Photo: Object {

    convenience init(image: UIImage) {
        self.init()
        self.imageUUID = image.saveInFileSystem()
    }

    // MARK: - persisted properties
    @objc dynamic var imageUUID: String!
    @objc dynamic var date: Date = Date()
    @objc dynamic var isFav: Bool = false
    let scenes = List<Scene>()
    let tags = List<Tag>()
}





