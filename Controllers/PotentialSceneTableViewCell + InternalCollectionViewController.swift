//
//  PotentialSceneTableViewCell + InternalCollectionViewController.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-13.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit

// MARK: Collection view data source
extension PotentialSceneTableViewCell:  UICollectionViewDataSource {
    
    fileprivate var collectionViewCellIdentifier: String {
        return "potentialSceneCollectionViewCell"
    }
    
    func addCollectionView() {
        
        potentialSceneCollectionView.backgroundColor = UIColor.clear
        potentialSceneCollectionView.dataSource = self
        potentialSceneCollectionView.allowsSelection = false
        potentialSceneCollectionView.collectionViewLayout = PotentialSceneCollectionViewLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scenes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! PotentialSceneCollectionViewCell
        
        cell.setup(by: scenes[indexPath.row])
        
        return cell
    }
}
