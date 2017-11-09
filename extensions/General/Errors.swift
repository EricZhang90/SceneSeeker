//
//  Errors.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-01.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import Foundation

// MARK: - Error interface
protocol GeneralError: Error {
    var code: Int { get }
    var error: String { get }
}

// MARK: Simple version of URLError, starts with 1XXX
struct NetworkURLError: GeneralError {

    let code: Int
    let error: String
    
    init(kind: URLError.Code) {
        
        code = 1000 + kind.rawValue
        
        switch kind {
        case .notConnectedToInternet:
            error = "Not Internet Connection"
        case .networkConnectionLost:
            error = "Internet Connection Lost"
        case .timedOut:
            error = "Connection Time Out"
        default:
            error = "URL Error"
        }
    }
}

// MARK: Simple version of http error, starts with 2XXX
struct NetworkHTTPError: GeneralError {
    let code: Int
    let error: String
    
    init(kind: HTTPURLResponse, error: String) {
        code = 2000 + kind.statusCode
        self.error = "HTTP Error: " + error
    }
    
    init(error: String) {
        code = 2000
        self.error = error
    }
}

// MARK: Data formate error, starts with 3XXX
struct DataFromateError: GeneralError {
    
    let code: Int
    let error: String
    
    enum Kind: Int {
        case JSON = 100
        case XML = 200
        case Binary = 300
    }
    
    init(kind: Kind, error: String) {
        
        code = 3000 + kind.rawValue
        
        switch kind {
            
        case .JSON:
            self.error = "JSON: " + error
        case .XML:
            self.error = "XML: " + error
        case .Binary:
            self.error = "Binary: " + error
        }
    }
}

// MARK: Image process Error, starts with 4XXX
struct ImageProcessError: GeneralError {
    
    let code: Int
    let error: String
    
    enum Kind: Int {
        case MLCoreModel = 100
        case MLCoreProcess = 200
        case convert = 300
    }
    
    init(kind: Kind, error: String) {
        code = 4000 + kind.rawValue
        
        switch kind {
        case .MLCoreModel:
            self.error = "Machine Learning Model Error: " + error
        case .MLCoreProcess:
            self.error = "Machine Learning Process Error: " + error
        case .convert:
            self.error = "Image Convertion: " + error
        }
        
    }
    
}

