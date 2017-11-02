//
//  AlertShortcut.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-30.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    // present a error/warming and dismiss it in 1 second(as default)
    class func present(in vc:UIViewController, message: String, last: Double = 1, completion: (()-> Void)?) {
        
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        
        vc.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + last, execute: {
                alert.dismiss(animated: true){
                    if let completion = completion {
                        completion()
                    }
                }
            })
        }
    }
}
