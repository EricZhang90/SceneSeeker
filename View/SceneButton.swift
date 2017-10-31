//
//  SceneButton.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-27.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class SceneButton: UIButton, Shapable{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorner()
        shadowView()
    }
}
//
//extension SceneButton {
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//}

