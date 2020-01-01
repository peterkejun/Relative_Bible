//
//  BibleData+FamilyTree.swift
//  Bible
//
//  Created by Peter Ke on 2019-10-07.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

extension BibleData {
    
    static func characterConnections(id: Int) -> [String: [Int]] {
        if let db = self.database {
            let statement = "SELECT parentOf, partnerOf, childOf, knows FROM Characters WHERE id = \(id);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var dict: [String: [Int]] = [:]
                if let parentOf = self.convertToInt(SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 0)) {
                    dict["parentOf"] = parentOf
                }
                if let partnerOf = self.convertToInt(SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 1)) {
                    dict["partnerOf"] = partnerOf
                }
                if let childOf = self.convertToInt(SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 2)) {
                    dict["childOf"] = childOf
                }
                if let knows = self.convertToInt(SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 3)) {
                    dict["knows"] = knows
                }
                return dict
            }
        }
        return [:]
    }
    
    private static func convertToInt(_ str: String?) -> [Int]? {
        return str?.components(separatedBy: ",").dropLast().map({ Int($0)! })
    }
    
}
