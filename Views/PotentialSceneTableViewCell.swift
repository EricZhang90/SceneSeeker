//
//  potentialSceneTableViewCell.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-13.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class PotentialSceneTableViewCell: UITableViewCell {

    
    @IBOutlet weak var potentialSceneCollectionView: UICollectionView!
    
    var scenes = [Scene]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addCollectionView()
    }
    
    func setup(with scenes:[Scene]) {
        
        self.scenes = scenes
        
        potentialSceneCollectionView.reloadData()
    }
}




