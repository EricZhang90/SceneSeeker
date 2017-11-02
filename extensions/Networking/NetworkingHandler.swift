//
//  NetworkingHandler.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-01.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingHanlder {
    
    class fileprivate var isConnected: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

// MARK: Image download/upload
extension NetworkingHanlder {
    
    class Image {
        
        typealias uploadProgress = (_ percent: Float) -> Void
        typealias uploadFinish = (_ tags: [String]) -> Void
        typealias downloadTags = ([String]) -> Void
        
        class func upload(image: UIImage, progressCompletion: @escaping uploadProgress, completion: @escaping  uploadFinish) {
            
            guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
                print("Could not get JPEG representation of UIImage")
                return
            }

            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(imageData,
                                             withName: "imagefile",
                                             fileName: "image.jpg",
                                             mimeType: "image/jpeg")
            },
                with: ImaggaRouter.content) { result in
                    
                    switch result {
                    case .success(let uploadRequest, _, _):
                        uploadRequest.uploadProgress{ progress in
                            progressCompletion(Float(progress.fractionCompleted))
                        }
                        
                        uploadRequest.validate()
                        
                        uploadRequest.responseJSON { response in
                            guard response.result.isSuccess else {
                                print("Error while uploading file: \(String(describing: response.result.error))")
                                completion([String]())
                                return
                            }
                            
                            guard let json = response.result.value as? [String: Any],
                                let uploadedFiles = json["uploaded"] as? [[String: Any]],
                                let firstFile = uploadedFiles.first,
                                let firstFileId = firstFile["id"] as? String else {
                                    print("Invalid information received from service")
                                    completion([String]())
                                    return
                            }
                            
                            print("Content uploaded with ID: \(firstFileId)")
                            
                            
                            donwloadTags(contentID: firstFileId) { tags in
                                
                                completion(tags)
                            }
                        }
                        
                    case .failure(let err):
                        print("upload fail: \(err)")
                    }
                    
            }
        }
        
        fileprivate class func donwloadTags(contentID: String, completion: @escaping downloadTags) {
            
            Alamofire.request(ImaggaRouter.tags(contentID))
                .responseJSON{ response in
                    
                    guard response.result.isSuccess else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        completion([String]())
                        return
                    }
                    
                    guard let json = response.result.value as? [String: Any],
                        let results = json["results"] as? [[String: Any]],
                        let firstObject = results.first,
                        let tagsAndConfidences = firstObject["tags"] as? [[String: Any]] else {
                            print("Invalid tag information received from the service")
                            completion([String]())
                            return
                    }
                    
                    let tags = tagsAndConfidences.flatMap{ dict in
                        return dict["tag"] as? String
                    }
                    
                    completion(tags)
            }
        }
    }
}
