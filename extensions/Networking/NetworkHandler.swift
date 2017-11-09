//
//  NetworkingHandler.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-01.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkHanlder {

    func checkNetworkConnection() -> Bool
    
}

extension NetworkHanlder {
    
    func checkNetworkConnection() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

