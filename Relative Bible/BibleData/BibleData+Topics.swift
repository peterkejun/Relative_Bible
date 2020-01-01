//
//  BibleData+Topics.swift
//  Bible
//
//  Created by Jun Ke on 8/23/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

extension BibleData {
    
    static var topics: [String] {
        if let db = self.database {
            let statement = "SELECT topic FROM Topics;"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var arr: [String] = []
                repeat {
                    let topic = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
                    arr.append(topic)
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return arr
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return []
    }
    
    static func topics(ofInitial initial: String) -> [String] {
        if let db = self.database {
            let statement = "SELECT topic FROM Topics WHERE initial = '\(initial.capitalized)';"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var arr: [String] = []
                repeat {
                    arr.append(SQLiteHandler.string(queryStatement: queryStatement, index: 0))
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return arr
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return []
    }
    
    static func numTopics(initial: String) -> Int {
        if let db = self.database {
            let statement = "SELECT Count(*) FROM Topics WHERE initial = '\(initial.capitalized)';"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let count = SQLiteHandler.integer(queryStatement: queryStatement, index: 0)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return count
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return -1
    }
    
    static var topicInitials: [String] {
        if let db = self.database {
            let statement = "SELECT DISTINCT initial FROM Topics;"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var arr: [String] = []
                repeat {
                    arr.append(SQLiteHandler.string(queryStatement: queryStatement, index: 0))
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return arr
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return []
    }
    
    static func initialsOfTopicsMatching(text: String) -> [String] {
        if let db = self.database {
            let escapedText = text.replacingOccurrences(of: "'", with: "`")
            let statement = "SELECT DISTINCT initial FROM Topics WHERE (topic LIKE '\(escapedText)%') OR (topic LIKE '% \(escapedText)%') OR (topic LIKE ' %\(escapedText)') ORDER BY topic ASC;"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var arr: [String] = []
                repeat {
                    arr.append(SQLiteHandler.string(queryStatement: queryStatement, index: 0))
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return arr
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return []
    }
    
    static func topics(ofInitial initial: String, andMatching text: String) -> [String] {
        if let db = self.database {
            let escapedText = text.replacingOccurrences(of: "'", with: "`")
            let statement = "SELECT DISTINCT topic FROM Topics WHERE initial = '\(initial)' AND ((topic LIKE '\(escapedText)%') OR (topic LIKE '% \(escapedText)%') OR (topic LIKE ' %\(escapedText)')) ORDER BY topic ASC;"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var arr: [String] = []
                repeat {
                    arr.append(SQLiteHandler.string(queryStatement: queryStatement, index: 0))
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return arr
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return []
    }
    
    static func discussion(topic: String) -> String? {
        if let db = self.database {
            let statement = "SELECT discussion FROM Topics WHERE topic = '\(topic)';"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let discussion = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return discussion
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return nil
    }
    
}

