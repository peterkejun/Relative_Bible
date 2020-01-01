//
//  SqliteHandler.swift
//  Bible
//
//  Created by Jun Ke on 8/4/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteHandler {
    
    static func loadDatabase(path: String) -> OpaquePointer? {
        var db: OpaquePointer?
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("Successfully opened connection to \(path)")
        } else {
            print("Unable to open \(path)")
            db = nil
        }
        return db
    }
    
    static func loadDatabase(name: String, type: String) -> OpaquePointer? {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            print("path for \(name).\(type) found nil")
            return nil
        }
        var db: OpaquePointer?
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("Successfully opened connetion to \(name).\(type) database")
        } else {
            print("Unable to open \(name).\(type) database")
            db = nil
        }
        return db
    }
    
    static func countRows(database: OpaquePointer?, tableName: String) -> Int {
        let statement = "SELECT COUNT(*) FROM [\(tableName)];"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, statement, -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let count = sqlite3_column_int(queryStatement, 0)
                return Int(count)
            }
        }
        return 0
    }
    
    static func clear(database: OpaquePointer?, tableName: String) {
        let statement = "DELETE FROM [\(tableName)];"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, statement, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("database cleared")
            } else {
                print("database cannot be cleared")
            }
        } else {
            print("clear query statement cannot be prepared")
        }
        sqlite3_finalize(queryStatement)
    }
    
    static func allEntries(db: OpaquePointer?, tableName: String) -> OpaquePointer? {
        let queryStatementString = "SELECT * FROM [\(tableName)];"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                return queryStatement
            }
        } else {
            print("query statement could not be prepared")
            print(queryStatementString)
        }
        return nil
    }
    
    static func queryNeedFinalize(database: OpaquePointer?, statement: String) -> OpaquePointer? {
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, statement, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                return queryStatement
            }
        } else {
            print("query statement could not be prepared")
            print(statement)
        }
        return nil
    }
    
    static func stepQueryStatement(_ queryStatement: OpaquePointer?) -> Bool {
        if sqlite3_step(queryStatement) == SQLITE_ROW {
            return true
        } else {
            return false
        }
    }
    
    static func finalize(queryStatement: OpaquePointer?) {
        sqlite3_finalize(queryStatement)
    }
    
    static func update(db: OpaquePointer?, statement: String) {
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, statement, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("Successfully updated")
            } else {
                print("Update failed")
                print(statement)
            }
        } else {
            print("query statement for update could not be prepared")
            print(statement)
        }
        sqlite3_finalize(queryStatement)
    }
    
    static func string(queryStatement: OpaquePointer?, index: Int32) -> String {
        return String.init(cString: sqlite3_column_text(queryStatement, index))
    }
    
    static func stringOptional(queryStatement: OpaquePointer?, index: Int32) -> String? {
        if let cString = sqlite3_column_text(queryStatement, index) {
            return String.init(cString: cString)
        }
        return nil
    }
    
    static func integer(queryStatement: OpaquePointer?, index: Int32) -> Int {
        return Int(sqlite3_column_int(queryStatement, index))
    }
    
    static func integerOptional(queryStatement: OpaquePointer?, index: Int32) -> Int? {
        let integer = self.integer(queryStatement: queryStatement, index: index)
        if integer == 0 {
            return nil
        }
        return integer
    }
    
    static func double(queryStatement: OpaquePointer?, index: Int32) -> Double {
        return sqlite3_column_double(queryStatement, index)
        
    }
    
    static func doubleOptional(queryStatement: OpaquePointer?, index: Int32) -> Double? {
        let double = self.double(queryStatement: queryStatement, index: index)
        if double == 0 {
            return nil
        }
        return double
    }
    
    static func insert(db: OpaquePointer?, tableName: String, fields: [String], values: [NSObject], types: [FieldType]) {
        var insertStatementString = "INSERT INTO [\(tableName)] ("
        for field in fields {
            insertStatementString.append(field + ", ")
        }
        insertStatementString.removeLast(2)
        insertStatementString.append(") VALUES (")
        for (n, value) in values.enumerated() {
            if types[n] == FieldType.INTEGER {
                let number = value as! NSNumber
                insertStatementString.append("\(number.int32Value), ")
            } else if types[n] == FieldType.TEXT {
                let string = value as! NSString
                insertStatementString.append("'\(string as String)', ")
            }
        }
        insertStatementString.removeLast(2)
        insertStatementString.append(");")
        
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("successfully inserted")
            } else {
                print("insert failed")
            }
        } else {
            print("insertStatement could not be prepared")
            print(insertStatementString)
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    static func containsEntry(db: OpaquePointer?, tableName: String, fields: [String], values: [NSObject], types: [FieldType]) -> Bool {
        var queryStatementString = "SELECT * FROM [\(tableName)] WHERE "
        for (n, field) in fields.enumerated() {
            if types[n] == FieldType.INTEGER {
                let number = (values[n] as! NSNumber).intValue
                queryStatementString.append(field + " = \(number) ")
            } else if types[n] == FieldType.TEXT {
                let text = values[n] as! NSString
                queryStatementString.append(field + " = '" + (text as String) + "' ")
            }
            if n != fields.count - 1 {
                queryStatementString.append("AND ")
            }
        }
        queryStatementString.append("LIMIT 1;")
        
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                sqlite3_finalize(queryStatement)
                return true
            } else {
                sqlite3_finalize(queryStatement)
                return false
            }
        } else {
            print("query statement could not be prepared")
            print(queryStatementString)
            sqlite3_finalize(queryStatement)
            return false
        }
    }
    
    static func deleteFirstOccurrence(db: OpaquePointer?, tableName: String, fields: [String], values: [NSObject], types: [FieldType]) {
        var queryStatementString = "DELETE FROM [\(tableName)] WHERE "
        for (n, field) in fields.enumerated() {
            if types[n] == FieldType.INTEGER {
                let number = (values[n] as! NSNumber).intValue
                queryStatementString.append(field + " = \(number) ")
            } else if types[n] == FieldType.TEXT {
                let text = values[n] as! NSString
                queryStatementString.append(field + " = '" + (text as String) + "' ")
            }
            if n != fields.count - 1 {
                queryStatementString.append("AND ")
            }
        }
        queryStatementString.append("LIMIT 1;")
        
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("successfully deleted first occurrence")
            } else {
                print("failed to delete first occurrence")
            }
            sqlite3_finalize(queryStatement)
        } else {
            print("query statement could not be prepared")
            print(queryStatementString)
            sqlite3_finalize(queryStatement)
        }
    }
    
    static func deleteAllOccurrences(db: OpaquePointer?, tableName: String, fields: [String], values: [NSObject], types: [FieldType]) {
        var queryStatementString = "DELETE FROM [\(tableName)] WHERE "
        for (n, field) in fields.enumerated() {
            if types[n] == FieldType.INTEGER {
                let number = (values[n] as! NSNumber).intValue
                queryStatementString.append(field + " = \(number) ")
            } else if types[n] == FieldType.TEXT {
                let text = values[n] as! NSString
                queryStatementString.append(field + " = '" + (text as String) + "' ")
            }
            if n != fields.count - 1 {
                queryStatementString.append("AND ")
            }
        }
        queryStatementString.append(";")
        
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("successfully deleted all occurrence")
            } else {
                print("failed to delete all occurrence")
            }
            sqlite3_finalize(queryStatement)
        } else {
            print("query statement could not be prepared")
            print(queryStatementString)
            sqlite3_finalize(queryStatement)
        }
    }
    
    enum FieldType {
        case INTEGER
        case TEXT
        case BOOL
    }
    
}


