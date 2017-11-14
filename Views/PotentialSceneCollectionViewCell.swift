//
//  PotentialSceneCollectionViewCell.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-13.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import Lottie

class PotentialSceneCollectionViewCell: UICollectionViewCell {
    
    var scene: Scene!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var loadingAnimation:LOTAnimationView?
    
    func setup(by scene: Scene) {
        
        self.scene = scene
        
        category.text = scene.identifier
        
        if let uuid = scene.similarScenePaths.first {
            
            if let loadingAnimation = loadingAnimation {
                loadingAnimation.stop()
                loadingAnimation.isHidden = true
                loadingAnimation.removeFromSuperview()
            }
            
            imageView.image = UIImage(uuid: uuid)
        }
        else {
            if loadingAnimation == nil {
                
                loadingAnimation = LOTAnimationView(name: "loading")
                loadingAnimation?.loopAnimation = true
                loadingAnimation!.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: imageView.frame.size.width,
                    height: imageView.frame.size.height)
                imageView.addSubview(loadingAnimation!)
                
            }
            loadingAnimation!.isHidden = false
            loadingAnimation!.play()
        }
        
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1.0
    }
    
}
