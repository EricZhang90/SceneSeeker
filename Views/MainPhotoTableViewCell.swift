//
//  AnalytisTableViewCell.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-31.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import RealmSwift
import Lottie

class MainPhotoTableViewCell: UITableViewCell, Shapable {

    var photo:Photo!
    
    
    
    @IBOutlet weak var tagsTextView: UITextView!
    @IBOutlet weak var favArea: UIView!
    @IBOutlet weak var photoView: UIImageView!
    
    var favBtn:LOTAnimatedSwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundCorner(radius: 10.0)
        
        setupTextView()
        
        addFavButton()
    }
    
    func setupCell(by photo: Photo) {
        
        self.photo = photo
        
        var tags = ""
        for tag in photo.tags {
            tags += "#\(tag.identifier) "
        }
        
        tagsTextView.text = tags
        
        photoView.image = UIImage(uuid: photo.imageUUID)
        
        if photo.isFav {
            favBtn.setOn(true, animated: false)
        }
        else {
            favBtn.setOn(false, animated: false)
        }
    }
    
    
    
    func setupTextView() {
        tagsTextView.delegate = self
        tagsTextView.layer.borderColor = UIColor.lightGray.cgColor
        tagsTextView.layer.borderWidth = 1.0
        tagsTextView.layer.backgroundColor = UIColor.clear.cgColor
        tagsTextView.layer.cornerRadius = 5.0
    }
    
    func addFavButton() {
        
        favBtn = LOTAnimatedSwitch.init(named: "TwitterHeart")
        favBtn.addTarget(self, action: #selector(addToFav(_:)), for: .valueChanged)
        
        favBtn.bounds.size.height = 200
        favBtn.bounds.size.width = 200
        favBtn.center = favArea.center
        favArea.backgroundColor = UIColor.clear
        contentView.addSubview(favBtn)
    }
    
    @objc func addToFav(_ animatedSwitch: LOTAnimatedSwitch) {
        
        let realm = try! Realm()
        
        try! realm.write {
            photo.isFav = !photo.isFav
        }
    }
}


// MARK: - Dismiss keyboard
extension MainPhotoTableViewCell: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tagsTextView.resignFirstResponder()
    }
}
