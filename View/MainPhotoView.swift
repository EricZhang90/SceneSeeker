//
//  MainPhotoView.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-30.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class MainPhotoView: UIImageView, Shapable {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorner()
        makeBoarder(width: 3.0)
        clipsToBounds = true
    }
}
