//
//  ImageRouter.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-31.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import Foundation
import Alamofire


enum ImaggaRouter: URLRequestConvertible {
    
    static let baseURLPath = "http://api.imagga.com/v1"
    static let authenticationToken = "Basic YWNjXzk0ZWY2NmI3Y2QxOTI5ODo0NjY1NmQyNDNhNzhhOTIyYWY3ZjkxN2I3MWEyNGEwMg=="
    
    case content
    case tags(String)
    case categories(String)
    
    var method: HTTPMethod {
        switch self {
        case .content:
            return .post
        case .tags:
            return .get
        case .categories:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .content:
            return "/content"
        case .tags:
            return "/tagging"
        case .categories:
            return "/categorizers"
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        
        let parameters: [String: Any] = {
            switch self {
            case .tags(let contentID):
                return ["content": contentID]
            case .categories(let contentID):
                return ["content": contentID]
            default:
                return [:]
            }
        }()
        
        let url = try ImaggaRouter.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        
        request.httpMethod = method.rawValue
        
        request.setValue(ImaggaRouter.authenticationToken, forHTTPHeaderField: "Authorization")
        
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
    
}
