//
//  RealmConfig.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-30.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmConfig {

    // MARK: pre-bundle data
    // copy predifined realm file to documents folder
    private static var copyInitialFile: Void = {
        let realmFile = Bundle.main.url(forResource: "default_v1", withExtension: "realm")!
        let desination = RealmConfig.mainConfig.fileURL!
        
        let copy = {
            try? FileManager.default.removeItem(at: desination)
            try! FileManager.default.copyItem(at: realmFile, to: desination)
        }
        
        let exist: Bool
        do {
            exist = try desination.checkResourceIsReachable()
        } catch {
            copy()
            return
        }
        
        if !exist {
            copy()
        }
    }()
    
    // MARK: main storage
    private static let mainConfig = Realm.Configuration(
        fileURL: URL.createFilePath(fileName: "main.realm"),
        schemaVersion: 1,
        migrationBlock: mainMigration,
        deleteRealmIfMigrationNeeded: true)
    
    private static func mainMigration(_ migration: Migration, _ oldSchemaVersion: UInt64) {
        if oldSchemaVersion == 1 {
            return
        }
        else {
            // for future needs..
        }
        
    }
    
    case main
    // MARK: TODO: add static case and security case in future
    
    var configuration: Realm.Configuration {
        
        switch self {
        case .main:
            _ = RealmConfig.copyInitialFile
            return RealmConfig.mainConfig
        }
    }
}






