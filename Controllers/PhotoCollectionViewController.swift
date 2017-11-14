//
//  PhotoCollectionViewController.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-30.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoCollectionViewController: UICollectionViewController {

    fileprivate let reuseIdentifier = "photoCell"
    
    fileprivate var photos: Results<Photo>!
    fileprivate var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        photos = realm.objects(Photo.self).sorted(byKeyPath: "date", ascending: true)
        
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        let imagePath = photos[indexPath.row].imageUUID!
        
        cell.layer.contents = UIImage(uuid: imagePath).cgImage
        
        //Debug.checkFilePermission(photos[indexPath.row].imageUUID)
        
        return cell
    }
}
