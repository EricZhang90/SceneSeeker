//
//  PotentialSceneCollectionViewLayout.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-13.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class PotentialSceneCollectionViewLayout: UICollectionViewFlowLayout {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        setupLayout()
    }
    
    func setupLayout() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: 120, height: 150)
    }
}

