//
//  BibleData+Characters.swift
//  Bible
//
//  Created by Jun Ke on 8/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

typealias CharacterInfo = (
    id: Int,
    name: String,
    gender: Int,
    description: String?,
    osisRefString: String?,
    birthYear: Int?,
    deathYear: Int?,
    birthPlaceID: Int?,
    deathPlaceID: Int?,
    alsoCalled: String?,
    writerOf: String?
)

extension BibleData {
    
    static var characterInitials: [String] {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "Z"]
    }
    
    static var characterIDs: [Int] {
        if let db = self.database {
            let statement = "SELECT id FROM Characters;"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var IDs: [Int] = []
                repeat {
                    let id = SQLiteHandler.integer(queryStatement: queryStatement, index: 0)
                    IDs.append(id)
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                return IDs
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return []
    }
    
    static func characterName(id: Int) -> String? {
        if let db = self.database {
            let statement = "SELECT name FROM Characters WHERE id = \(id);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let id = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return id
            }
        }
        return nil
    }
    
    static func gender(id: Int) -> Int {
        if let db = self.database {
            let statement = "SELECT gender FROM Characters WHERE id = \(id);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let gender = SQLiteHandler.integer(queryStatement: queryStatement, index: 0)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return gender
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return -1
    }
    
    static func characterIDs(ofInitial initial: String) -> [Int] {
        return self.characterIDs(withPrefix: initial)
    }
    
    static func characterIDs(withPrefix prefix: String) -> [Int] {
        if let db = self.database {
            let statement = "SELECT id, name FROM Characters WHERE name like '\(prefix)%' ORDER BY name COLLATE NOCASE ASC;"
            let query_statement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if query_statement != nil {
                var ids: [Int] = []
                repeat {
                    ids.append(SQLiteHandler.integer(queryStatement: query_statement, index: 0))
                } while SQLiteHandler.stepQueryStatement(query_statement)
                SQLiteHandler.finalize(queryStatement: query_statement)
                return ids
            }
            SQLiteHandler.finalize(queryStatement: query_statement)
        }
        return []
    }
    
    static func characterConcordanceString(id: Int) -> String? {
        if let db = self.database {
            let statement = "SELECT osisRef FROM Characters WHERE id = \(id);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let osisRefString = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 0)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return osisRefString
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return nil
    }
    
    static func characterInfo(id: Int) -> CharacterInfo? {
        if let db = self.database {
            let statement = "SELECT * FROM Characters WHERE id = \(id);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let name = SQLiteHandler.string(queryStatement: queryStatement, index: 1)
                let gender = SQLiteHandler.integer(queryStatement: queryStatement, index: 2)
                let description = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 3)
                let osisRefString = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 4)
                let birthYear = SQLiteHandler.integerOptional(queryStatement: queryStatement, index: 5)
                let deathYear = SQLiteHandler.integerOptional(queryStatement: queryStatement, index: 6)
                let birthPlaceID = SQLiteHandler.integerOptional(queryStatement: queryStatement, index: 7)
                let deathPlaceID = SQLiteHandler.integerOptional(queryStatement: queryStatement, index: 8)
                let alsoCalled = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 9)
                let writerOf = SQLiteHandler.stringOptional(queryStatement: queryStatement, index: 10)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return (id, name, gender, description, osisRefString, birthYear, deathYear, birthPlaceID, deathPlaceID, alsoCalled, writerOf)
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return nil
    }
    
//    static var charactersFullInfo: [Character] {
//        if let db = self.database {
//            let statement = "SELECT * FROM Characters;"
//            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
//            if queryStatement != nil {
//                var characters: [Character] = []
//                repeat {
//                    let name = SQLiteHandler.string(queryStatement: queryStatement, index: 1)
//                    let brief = SQLiteHandler.string(queryStatement: queryStatement, index: 2)
//                    let concordanceStrings = SQLiteHandler.string(queryStatement: queryStatement, index: 3).components(separatedBy: "///")
//                    let concordance = concordanceStrings.map({ VerseTag.init(description: $0) }).compactMap({$0})
//                    characters.append((name, brief, concordance))
//                } while SQLiteHandler.stepQueryStatement(queryStatement)
//                SQLiteHandler.finalize(queryStatement: queryStatement)
//                return characters
//            }
//            SQLiteHandler.finalize(queryStatement: queryStatement)
//        }
//        return []
//    }
//
//    static var characterNames: [String] {
//        if let db = self.database {
//            let statement = "SELECT name FROM Characters;"
//            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
//            if queryStatement != nil {
//                var names: [String] = []
//                repeat {
//                    let name = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
//                    names.append(name)
//                } while SQLiteHandler.stepQueryStatement(queryStatement)
//                SQLiteHandler.finalize(queryStatement: queryStatement)
//                return names
//            }
//            SQLiteHandler.finalize(queryStatement: queryStatement)
//        }
//        return []
//    }
//
//    static func concordance(ofCharacter name: String) -> [VerseTag] {
//        if let db = self.database {
//            let statement = "SELECT concordance FROM Characters WHERE name = '\(name)';"
//            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
//            if queryStatement != nil {
//                let concordanceStrings = SQLiteHandler.string(queryStatement: queryStatement, index: 0).components(separatedBy: "///")
//                let concordance = concordanceStrings.map({ VerseTag.init(description: $0) }).compactMap({$0})
//                SQLiteHandler.finalize(queryStatement: queryStatement)
//                return concordance
//            }
//            SQLiteHandler.finalize(queryStatement: queryStatement)
//        }
//        return []
//    }
//
//    static func brief(ofCharacter name: String) -> String? {
//        if let db = self.database {
//            let statement = "SELECT brief FROM Characters WHERE name = '\(name)';"
//            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
//            if queryStatement != nil {
//                let brief = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
//                SQLiteHandler.finalize(queryStatement: queryStatement)
//                return brief
//            }
//            SQLiteHandler.finalize(queryStatement: queryStatement)
//        }
//        return nil
//    }
//
//    static func characterNames(inVerse tag: VerseTag) -> [String] {
//        if let db = self.database {
//            let statement = "SELECT name FROM Characters WHERE (concordance LIKE '\(tag.description)///%') OR (concordance LIKE '%\(tag.description)///%') OR (concordance LIKE '%\(tag.description)///');"
//            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
//            if queryStatement != nil {
//                var names: [String] = []
//                repeat {
//                    names.append(SQLiteHandler.string(queryStatement: queryStatement, index: 0))
//                } while SQLiteHandler.stepQueryStatement(queryStatement)
//                SQLiteHandler.finalize(queryStatement: queryStatement)
//                return names
//            }
//            SQLiteHandler.finalize(queryStatement: queryStatement)
//        }
//        return []
//    }
    
}

