//
//  Errors.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-01.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import Foundation

// MARK: -
protocol NetworkError: Error {
    var code: Int { get }
    var error: String { get }
}

// MARK: simple version of URLError
struct NetworkURLError: NetworkError {

    let code: Int
    let error: String
    
    init(kind: URLError) {
        code = kind.code.rawValue
        switch kind.code {
        case URLError.Code.notConnectedToInternet:
            error = "Not Internet Connection"
        case URLError.Code.networkConnectionLost:
            error = "Internet Connection Lost"
        case URLError.Code.timedOut:
            error = "Connection Time Out"
        default:
            error = "URL Error"
        }
    }
}

// MARK: simple version of http error
struct NetworkHTTPError: NetworkError {
    let code: Int
    let error: String
    
    init(kind: HTTPURLResponse) {
        code = kind.statusCode
        error = "HTTP Error"
    }
}

