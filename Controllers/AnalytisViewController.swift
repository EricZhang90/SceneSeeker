//
//  AnalytisViewController.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-31.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import RealmSwift

class AnalytisViewController: UIViewController {

    @IBOutlet weak var tagTableView: UITableView!
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    fileprivate let cellIdentifier = "tagCell"
    
    var photo: Photo!
    var tags: List<Tag>!
    var categoires: List<Scene>!
    
    var cate = [Scene]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cateCell")
        
        title = "Result"
       
        let image = UIImage(uuid: photo.imageUUID)
        
        photoView.image = image
    
        tagTableView.layer.cornerRadius = 10
        tagTableView.layer.borderWidth = 2
        tagTableView.layer.borderColor = UIColor.lightText.cgColor
        
        progressView.isHidden = false
        
        let localDetector = SceneDetector(delegate: self, kind: .local)
        
        localDetector.detectScene(image)
        
        let remoteDetector = SceneDetector(delegate: self, kind: .internet)
        
        remoteDetector.detectScene(image)
        
        tags = photo.tags
        categoires = photo.scenes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Table view delegate
extension AnalytisViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tagTableView {
            return tags.count + categoires.count
        }
        else {
            return cate.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tagTableView {
            let cell = tagTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            if indexPath.row < tags.count {
                // tags
                cell.textLabel?.text = "\(tags[indexPath.row].identifier)"
            }
            else {
                // cate
                let index = indexPath.row - tags.count
                cell.textLabel?.text = "[IM] \(categoires[index].identifier) [\(categoires[index].confidence)]"
            }
            
            return cell
        }
        else {
            let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "cateCell", for: indexPath)
            
            let index = indexPath.row
            
            cell.textLabel?.text = "[OS] \(cate[index].identifier) [\(cate[index].confidence)]"
            
            return cell
        }
    }
}

// MARK: Image process delegate
extension AnalytisViewController: ImageProcessor {
    
    func processTags(_ tags: [Tag]) {
        
        progressView.isHidden = true
        
        let tags = tags.sorted { $0.confidence > $1.confidence }
        
        let realm = try! Realm()
        try! realm.write {
            for tag in tags {
                photo.tags.append(tag)
            }
        }
        tagTableView.reloadData()
    }
    
    func processCategories(_ categories: [Scene], kind: SceneDetector.Kind) {
        
        let categories = categories.sorted { $0.confidence > $1.confidence }
        
        if kind == .internet {
            
            let realm = try! Realm()
            try! realm.write {
                for cate in categories {
                    photo.scenes.append(cate)
                }
            }
            
            tagTableView.reloadData()
        }
        else {
            cate = categories
            
            categoriesTableView.reloadData()
        }
    }
    
    func processUploadProgress(_ percent: Float) {
        progressView.setProgress(percent, animated: true)
    }
    
    func handleError(error: GeneralError) {
        
    }
}

