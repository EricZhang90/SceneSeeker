//
//  ViewBasic.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-02.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(msg: String) {
        UIAlertController.present(in: self, message: msg, completion: nil)
    }
}
