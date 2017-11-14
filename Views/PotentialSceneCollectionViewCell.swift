//
//  PotentialSceneCollectionViewCell.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-13.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class PotentialSceneCollectionViewCell: UICollectionViewCell {
    
    var scene: Scene!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(by scene: Scene) {
        
        self.scene = scene
        
        category.text = scene.identifier
        
        if let uuid = scene.similarScenePaths.first {
            imageView.image = UIImage(uuid: uuid)
        }
        else {
            imageView.image = UIImage(named: "unliked")
        }
        
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1.0
    }
    
}
