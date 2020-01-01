//
//  UserData.swift
//  Bible
//
//  Created by Jun Ke on 8/16/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation
import SQLite3

class UserData {
    
    private(set) static var database: OpaquePointer?
    
    static func load() {
        let fileManager = FileManager.default
        let path = try! fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("UserData.db").path
        if !fileManager.fileExists(atPath: path) {
            let resourcePath = Bundle.main.path(forResource: "UserData", ofType: "db")!
            try! fileManager.copyItem(atPath: resourcePath, toPath: path)
        }
        self.database = SQLiteHandler.loadDatabase(path: path)
    }
    
}

