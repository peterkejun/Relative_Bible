//
//  BibleData+Places.swift
//  Bible
//
//  Created by Jun Ke on 9/20/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

typealias Place = (
    id: Int,
    name: String,
    alsoCalled: String?,
    latitude: Double?,
    longitude: Double?,
    precision: String?,
    featureType: String?,
    description: String?,
    source: String?,
    comments: String?,
    osisRefString: String?
)

extension BibleData {
    
    static var placeIDs: [Int] {
        if let db = self.database {
            let statement = "SELECT id FROM Places;"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var IDs: [Int] = []
                repeat {
                    let id = SQLiteHandler.integer(queryStatement: queryStatement, index: 0)
                    IDs.append(id)
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return IDs
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return []
    }
    
    static func placeName(id: Int) -> String? {
        if let db = self.database {
            let statement = "SELECT name FROM Places WHERE id = \(id);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let name = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return name
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return nil
    }
    
    static func placeInfo(id: Int) -> Place? {
        if let db = self.database {
            let statement = "SELECT * FROM Places WHERE id = \(id);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let name = SQLiteHandler.string(queryStatement: queryStatement, index: 1)
                let alsoCalled = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 2)
                let latitude = SQLiteHandler.doubleOptional(queryStatement: queryStatement, index: 3)
                let longitude = SQLiteHandler.doubleOptional(queryStatement: queryStatement, index: 4)
                let precision = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 5)
                let featureType = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 6)
                let description = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 7)
                let source = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 8)
                let comments = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 9)
                let osisRefString = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 10)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return (id, name, alsoCalled, latitude, longitude, precision, featureType, description, source, comments, osisRefString)
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return nil
    }
    
}

