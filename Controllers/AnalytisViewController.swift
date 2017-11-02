//
//  AnalytisViewController.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-31.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

class AnalytisViewController: UIViewController {

    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    fileprivate let cellIdentifier = "tagCell"
    
    var photo: Photo!
    var tags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        title = "Result"
        
        photoView.image = UIImage(uuid: photo.imageUUID)
    
        tagTableView.layer.cornerRadius = 10
        tagTableView.layer.borderWidth = 2
        tagTableView.layer.borderColor = UIColor.lightText.cgColor
        
        progressView.isHidden = false
        
        let progress: NetworkingHanlder.Image.uploadProgress = {
            [weak self] percent in
            self?.progressView.setProgress(percent, animated: true)
        }
        
        let finish: NetworkingHanlder.Image.uploadFinish = {
            [weak self] tags in
            
            self?.progressView.isHidden = true
            self?.tags = tags
            self?.tagTableView.reloadData()
        }
        
        let image = UIImage(uuid: photo.imageUUID)
        
        NetworkingHanlder.Image.upload(image: image, progressCompletion: progress, completion: finish)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Table view delgate
extension AnalytisViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tagTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = "\(tags[indexPath.row])"
        
        return cell
    }
    
    
}
