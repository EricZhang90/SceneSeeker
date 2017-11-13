//
//  AnalytisTableViewCell.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-31.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import RealmSwift

class MainPhotoTableViewCell: UITableViewCell, Shapable {

    var photo:Photo!
    
    
    @IBAction func addToFav(_ sender: Any) {
        
        let button = sender as! UIButton
        
        if photo.isFav {
            button.setImage(UIImage(named: "unliked"), for: .normal)
        }
        else {
            button.setImage(UIImage(named: "liked"), for: .normal)
        }
        
        let realm = try! Realm()
        
        try! realm.write {
            photo.isFav = !photo.isFav
        }
    }
    
    @IBOutlet weak var tagsTextView: UITextView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    
    func setupCell(by photo: Photo) {
        
        self.photo = photo
        
        var tags = ""
        for tag in photo.tags {
            tags += "#\(tag.identifier) "
        }
        
        tagsTextView.text = tags
        
        photoView.image = UIImage(uuid: photo.imageUUID)
        
        if photo.isFav {
            favButton.setImage(UIImage(named: "liked"), for: .normal)
        }
        else {
            favButton.setImage(UIImage(named: "unliked"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundCorner(radius: 10.0)
        
        tagsTextView.delegate = self
        tagsTextView.layer.borderColor = UIColor.lightGray.cgColor
        tagsTextView.layer.borderWidth = 1.0
        tagsTextView.layer.backgroundColor = UIColor.clear.cgColor
        tagsTextView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
