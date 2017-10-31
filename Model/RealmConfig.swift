//
//  RealmConfig.swift
//  SceneSeeker
//
//  Created by Lei zhang on 2017-10-30.
//  Copyright © 2017 lei zhang. All rights reserved.
//

import RealmSwift

enum RealmConfig {
    
    private static let mainConfig = Realm.Configuration(
        fileURL: URL.getFilePath(fileName: "main.realm"),
        schemaVersion: 1,
        migrationBlock: { migration, oldSchemaVersion in
            
            
        },
        deleteRealmIfMigrationNeeded: true)
    
    case main
    
    var configuration: Realm.Configuration {
        
        switch self {
        case .main:
            return RealmConfig.mainConfig
        }
    }
}






