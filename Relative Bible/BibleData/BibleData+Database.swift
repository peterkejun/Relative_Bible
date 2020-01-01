//
//  BibleData+Database.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

class BibleData {
    
    private(set) static var database: OpaquePointer?
    private(set) static var textDatabases: [BibleVersion : OpaquePointer?] = [:]
    
    static func load() {
        self.database = SQLiteHandler.loadDatabase(name: "BibleData", type: "db")
        self.textDatabases[BibleVersion.KJV] = SQLiteHandler.loadDatabase(name: "KJV", type: "db")
        self.textDatabases[BibleVersion.CUV_sim] = SQLiteHandler.loadDatabase(name: "CUV_sim", type: "db")
        self.textDatabases[BibleVersion.CUV_tra] = SQLiteHandler.loadDatabase(name: "CUV_tra", type: "db")
        self.textDatabases[BibleVersion.ASV] = SQLiteHandler.loadDatabase(name: "ASV", type: "db")
        self.textDatabases[BibleVersion.JCL] = SQLiteHandler.loadDatabase(name: "JCL", type: "db")
        self.textDatabases[BibleVersion.JCO] = SQLiteHandler.loadDatabase(name: "JCO", type: "db")
        self.textDatabases[BibleVersion.KRV] = SQLiteHandler.loadDatabase(name: "KRV", type: "db")
        self.textDatabases[BibleVersion.LSG] = SQLiteHandler.loadDatabase(name: "LSG", type: "db")
    }
    
    static func testament(bookEnglish: String) -> VerseTag.Testament {
        guard let index = self.wholeBibleNames.firstIndex(of: bookEnglish) else { return .OldTestament }
        if index < self.numBooksOldTestament {
            return .OldTestament
        }
        return .NewTestament
    }
    
    static func brief(osisRef: String) -> String? {
        if let db = self.database {
            let statement = "SELECT brief FROM BookBrief WHERE osisRef = '\(osisRef)';"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let brief = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return brief.replacingOccurrences(of: "\\t", with: "")
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return nil
    }
    
}

