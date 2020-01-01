//
//  UserData+Like.swift
//  Bible
//
//  Created by Jun Ke on 8/22/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

extension UserData {
    
    static func isLiked(book: String, chapter: Int, verse: Int) -> Bool {
        if let db = self.database {
            let statement = "SELECT * FROM Like WHERE book = '\(book)' AND chapter = '\(chapter)' AND verse = '\(verse)' LIMIT 1;"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            return queryStatement != nil
        }
        return false
    }
    
    static func addLiked(book: String, chapter: Int, verse: Int) {
        if !self.isLiked(book: book, chapter: chapter, verse: verse), let db = self.database {
            SQLiteHandler.insert(db: db, tableName: "Like", fields: ["book", "chapter", "verse"], values: [book as NSString, NSNumber.init(value: chapter) as NSObject, NSNumber.init(value: verse) as NSObject], types: [.TEXT, .INTEGER, .INTEGER])
        }
    }
    
    static func removeLiked(book: String, chapter: Int, verse: Int) {
        if let db = self.database {
            SQLiteHandler.deleteAllOccurrences(db: db, tableName: "Like", fields: ["book", "chapter", "verse"], values: [book as NSString, NSNumber.init(value: chapter) as NSObject, NSNumber.init(value: verse) as NSObject], types: [.TEXT, .INTEGER, .INTEGER])
        }
    }
    
    static var likedVerseTags: [VerseTag] {
        if let db = self.database {
            let statement = "SELECT * FROM Like;"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var verseTags: [VerseTag] = []
                repeat {
                    let book = SQLiteHandler.string(queryStatement: queryStatement, index: 1)
                    let chapter = SQLiteHandler.integer(queryStatement: queryStatement, index: 2)
                    let verseNumber = SQLiteHandler.integer(queryStatement: queryStatement, index: 3)
                    let verseTag = VerseTag.init(book: book, chapter: chapter, verseNumber: verseNumber)
                    verseTags.append(verseTag)
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return verseTags
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return []
    }
    
}

