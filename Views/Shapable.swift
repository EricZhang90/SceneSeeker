//
//  RounderCorner.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-27.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import Foundation
import UIKit

protocol Shapable {
    var layer: CALayer {get}
}

extension Shapable {
    
    func roundCorner(_ radius: CGFloat = 0) {

        layer.cornerRadius = radius == 0 ? layer.frame.size.height / 2 : radius
    }
    
    func shadowView() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 7, height: 10)
    }
    
    func makeBoarder(width: CGFloat = 1, color: CGColor = UIColor.white.cgColor) {
        
        layer.borderColor = color
        layer.borderWidth = width
    }
}










