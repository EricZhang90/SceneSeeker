//
//  UIImage+MachineLearning.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-08.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire

class SceneDetector {
    
    enum Kind {
        case local
        case internet
    }
    
    let kind: Kind
    
    weak var delegate: ImageProcessor?
    
    required init(delegate: ImageProcessor, kind: Kind) {
        self.delegate = delegate
        self.kind = kind
    }
    
    func detectScene(_ image: UIImage) {
        
        switch kind {
        case .local:
            detectByML(image: image)
        case .internet:
            detectByServer(image: image)
        }
    }
    
}


// MARK: - Local detect approach.
// NOTE: all methods are defaultly exectued in global queue, so all UI updates must be manully wrapped by "DispatchQueue.main.sync/async"
extension SceneDetector {
    
    private func detectByML(image: UIImage) {
        
        guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) else {
            let e = ImageProcessError(kind: .MLCoreModel, error: "fail to wrap Google Model".debugDescription)
            delegate?.handleError(error: e)
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [unowned self](request, error) in
            
            guard error == nil else {
                let e = ImageProcessError(kind: .MLCoreProcess, error: error.debugDescription)
                self.delegate?.handleError(error: e)
                return
            }
            
            if var results = request.results as? [VNClassificationObservation],
                results.count > 0 {
                
                if results.count > 4 {
                    results = Array(results.prefix(4))
                }
                
                let scenes = results.flatMap { result in
                    return Scene(identifier: result.identifier, confidence: Double(result.confidence))
                }
                
                self.delegate?.processCategories(scenes, kind: self.kind)
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
    
}


// MARK: Remote detect approach
// NOTE: all methods are defaultly exectued in global queue, so all UI updates must be wrapped by "DispatchQueue.main."
extension SceneDetector: NetworkHanlder {
    
    //    typealias downloadTags = ([Tag]) -> Void
    //    typealias downloadCategories = ([Scene]) -> Void
    
    private func detectByServer(image: UIImage) {
        
        guard checkNetworkConnection() else {
            let e = NetworkURLError(kind: .notConnectedToInternet)
            delegate?.handleError(error: e)
            return
        }
        
        upload(image: image) { [unowned self] contentID in
            
            self.downlaodTags(contentID: contentID) { [unowned self] tags in
                self.delegate?.processTags(tags)
            }
            
            self.downloadCategoires(contentID: contentID) { [unowned self] categories in
                
                self.delegate?.processCategories(categories, kind: self.kind)
            }
        }
    }
    
    
    private func upload(image: UIImage, completion: @escaping (String) -> Void) {
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            let e = ImageProcessError(kind: .convert, error: "Could not get JPEG representation of UIImage")
            delegate?.handleError(error: e)
            return
        }
        
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData,
                                         withName: "imageFile",
                                         fileName: "image.jpg",
                                         mimeType: "image/jpeg")
                
            },  with: ImaggaRouter.content) { result in
                
                switch result {
                case .failure(let error):
                    
                    let e = NetworkHTTPError(error: error.localizedDescription)
                    self.delegate?.handleError(error: e)
                    
                case .success(let uploadRequest, _, _):
                    
                    uploadRequest.uploadProgress{ [unowned self] progress in
                        self.delegate?.processUploadProgress(Float(progress.fractionCompleted))
                    }
                    
                    uploadRequest.validate()
                    
                    let q = DispatchQueue.global(qos: .userInitiated)
                    
                    uploadRequest.responseJSON(queue: q) { [unowned self] response in
                        
                        guard response.result.isSuccess else {
                            let e = NetworkHTTPError(kind: response.response!, error: "fail to upload image")
                            self.delegate?.handleError(error: e)
                            return
                        }
                        
                        guard
                            let json = response.result.value as? [String: Any],
                            let uploadedFiles = json["uploaded"] as? [[String: Any]],
                            let firstFile = uploadedFiles.first,
                            let contentID = firstFile["id"] as? String else {
                                let e = DataFromateError(kind: .JSON, error: "Invalid contentID information received from service")
                                self.delegate?.handleError(error: e)
                                return
                        }
                        
                        completion(contentID)
                    }
                }
        }
    }
    
    private func downlaodTags(contentID: String, completion: @escaping ([Tag]) -> Void) {
        
        let q = DispatchQueue.global(qos: .userInitiated)
        Alamofire
            .request(ImaggaRouter.tags(contentID))
            .responseJSON(queue: q) { [unowned self] response in
                
                guard response.result.isSuccess else {
                    let e = NetworkHTTPError(kind: response.response!, error: "fail to dowonload tags")
                    self.delegate?.handleError(error: e)
                    return
                }
                
                guard
                    let json = response.result.value as? [String: Any],
                    let results = json["results"] as? [[String: Any]],
                    let firstObject = results.first,
                    let tagsAndConfidences = firstObject["tags"] as? [[String: Any]] else {
                        
                        let e = DataFromateError(kind: .JSON, error: "Invalid tag information received from the service.")
                        self.delegate?.handleError(error: e)
                        return
                }
                
                let tags: [Tag] = tagsAndConfidences.flatMap{ dict in
                    let identifier = dict["tag"] as! String
                    let confidence = dict["confidence"] as! Double
                    return Tag(identifier: identifier, confidence: confidence)
                }
                
                completion(tags)
        }
    }
    
    
    private func downloadCategoires(contentID: String, completion: @escaping ([Scene]) -> Void) {
        
        let q = DispatchQueue.global(qos: .userInitiated)
        Alamofire
            .request(ImaggaRouter.categories(contentID))
            .responseJSON(queue: q) { [unowned self] response in
                
                guard response.result.isSuccess else {
                    let e = NetworkHTTPError(kind: response.response!, error: "Fail to download categories")
                    self.delegate?.handleError(error: e)
                    return
                }
                
                guard
                    let json = response.result.value as? [String: Any],
                    let results = json["results"] as? [[String: Any]],
                    let firstObj = results.first,
                    var identifiersAndConfidences = firstObj["categories"] as? [[String: Any]] else {
                        
                        let e = DataFromateError(kind: .JSON, error: "Invalid category information received from the service.")
                        self.delegate?.handleError(error: e)
                        return
                }
                
                if identifiersAndConfidences.count > 4 {
                    identifiersAndConfidences = Array(identifiersAndConfidences.prefix(4))
                }
                
                let categories: [Scene] = identifiersAndConfidences.flatMap { dict in
                    let identifier = dict["name"] as! String
                    let confidence = dict["confidence"] as! Double
                    return Scene(identifier: identifier, confidence: confidence)
                }
                
                completion(categories)
        }
    }
}








