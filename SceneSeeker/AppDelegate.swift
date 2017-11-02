//
//  AppDelegate.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-27.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import RealmSwift


let debug = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupUI()
        
        setupDatabase()
        
        if debug {
            cleanData()
        }
        
        print("Curruent app directory: [\(URL.createFilePath(fileName: ""))]")
        
        return true
    }
    
    private func setupUI() {
        
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "AlNile-Bold", size: 22)!]
    }
    
    private func setupDatabase() {
        Realm.Configuration.defaultConfiguration = RealmConfig.main.configuration
        
        var isDir: ObjCBool = false
        let imageDocumentURL = URL.createFilePath(fileName: "images/")
    
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: imageDocumentURL.path, isDirectory: &isDir) {
            try! fileManager.createDirectory(at: imageDocumentURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // Delete all images and models for test/develop purpose
    private func cleanData() {
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        let fileManager = FileManager.default
        
        var isDir: ObjCBool = false
        let imageDocumentURL = URL.createFilePath(fileName: "images/")
        
        if fileManager.fileExists(atPath: imageDocumentURL.path, isDirectory: &isDir) {
            try! fileManager.removeItem(at: imageDocumentURL)
            try! fileManager.createDirectory(at: imageDocumentURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
}

