//
//  AppDelegate.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-27.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupUI()
        
        Realm.Configuration.defaultConfiguration = RealmConfig.main.configuration
        
        return true
    }
    
    private func setupUI() {
        
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "AlNile-Bold", size: 22)!]
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
}

