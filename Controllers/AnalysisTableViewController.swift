//
//  AnalysisTableViewController.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-11-13.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import RealmSwift

class AnalysisTableViewController: UITableViewController {

    fileprivate let mainPhotoCellIdentifier = "mainPhotoTableViewCell"
    fileprivate let potentialSceneCellIdentifier = "potentialSceneTableViewCell"
    
    fileprivate let headerHeight:CGFloat = 30.0
    
    var photo: Photo!
    var realm: Realm!
    
    var localDetector: SceneDetector!
    var remoteDetector: SceneDetector!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try! Realm()

        setupUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        makeTransparentTableView()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let image = UIImage(uuid: photo.imageUUID)
        
        localDetector = SceneDetector(delegate: self, kind: .local)
        
        localDetector.detectScene(image)
        
        remoteDetector = SceneDetector(delegate: self, kind: .internet)
        
        remoteDetector.detectScene(image)
    }
}


// MARK: - make transparent table view with a background image
extension AnalysisTableViewController {
    
    func makeTransparentTableView() {
        let backgroundImage = #imageLiteral(resourceName: "background2")
        tableView.backgroundView = UIImageView(image: backgroundImage)
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.init(white: 1.0, alpha: 0.3)
    }
}

// MARK: - Table view data source
extension AnalysisTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: mainPhotoCellIdentifier, for: indexPath) as! MainPhotoTableViewCell
            cell.setupCell(by: photo)
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: potentialSceneCellIdentifier, for: indexPath)
            
            return cell
        }
    }
}


// MARK: Set section headers
extension AnalysisTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title: String!
        switch section {
        case 1:
            title = "  Apple Engine Suggests: "
        case 2:
            title = "  Imagga Engine Suggests: "
        default:
            title = ""
        }
        
        let width = tableView.frame.size.width
        let frame = CGRect(x: 10, y: 0, width: width, height: headerHeight)
        
        let headerTitle = UILabel(frame: frame)
        headerTitle.text = title
        headerTitle.font = UIFont.boldSystemFont(ofSize: 15)
        headerTitle.textColor = UIColor.gray
        
        return headerTitle
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

// MARK: Image process delegate
extension AnalysisTableViewController: ImageProcessor {
    
    func processTags(_ tags: [Tag]) {
        
        let tags = tags.sorted { $0.confidence > $1.confidence }
        
        DispatchQueue.main.async {
            
            try! self.realm.write {
                for tag in tags {
                    self.photo.tags.append(tag)
                }
            }
            
            let indexPath = IndexPath(item: 0, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }

    }
    
    func processCategories(_ categories: [Scene], kind: SceneDetector.Kind) {
        
    }
    
    func handleError(error: GeneralError) {
        print(error.error)
    }
}
