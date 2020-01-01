//
//  BibleData+Text.swift
//  Bible
//
//  Created by Jun Ke on 8/21/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

extension BibleData {
    
    static func numVerses(book: String, chapter: Int) -> Int {
        if let db = self.textDatabases[BibleVersion.KJV] {
            let statement = "SELECT Count(*) FROM [\(book)];"
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
    
    static func bibleText(book: String, chapter: Int, verseNumber: Int, version: BibleVersion = BibleVersion.KJV) -> String? {
        if let db = self.textDatabases[version], let bookNative = self.convertToNative(bookEnglish: book, toVersion: version) {
            let statement = "SELECT content FROM [\(bookNative)] WHERE chapter = \(chapter) AND verse = \(verseNumber);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let text = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return text
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return nil
    }
    
    static func bibleText(book: String, chapter: Int, version: BibleVersion = BibleVersion.KJV) -> [String]? {
        if let db = self.textDatabases[version], let bookNative = self.convertToNative(bookEnglish: book, toVersion: version) {
            let statement = "SELECT content FROM [\(bookNative)] WHERE chapter = \(chapter);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var texts: [String] = []
                repeat {
                    let text = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
                    texts.append(text)
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return texts
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return nil
    }
    
    static func bibleText(contains text: String, inBook book: String, chapter: Int, version: BibleVersion) -> [Verse] {
        if let db = self.textDatabases[version], let bookNative = self.convertToNative(bookEnglish: book, toVersion: version) {
            let statement = "SELECT * FROM [\(bookNative)] WHERE chapter = \(chapter) AND (content LIKE '\(text)%' OR content LIKE '%\(text)%' OR content LIKE '%\(text)');"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var verses: [Verse] = []
                repeat {
                    let verseNumber = SQLiteHandler.integer(queryStatement: queryStatement, index: 3)
                    let content = SQLiteHandler.string(queryStatement: queryStatement, index: 4)
                    verses.append(Verse.init(book: book, chapter: chapter, verseNumber: verseNumber, content: content))
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return verses
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return []
    }
    
    static func convertToNative(bookEnglish: String, toVersion version: BibleVersion) -> String? {
        if let db_en = self.textDatabases[BibleVersion.KJV], let db_nt = self.textDatabases[version] {
            var statement = "SELECT id FROM books WHERE book = '\(bookEnglish)';"
            var queryStatement = SQLiteHandler.queryNeedFinalize(database: db_en, statement: statement)
            let id = SQLiteHandler.integer(queryStatement: queryStatement, index: 0)
            SQLiteHandler.finalize(queryStatement: queryStatement)
            statement = "SELECT book FROM books WHERE id = \(id);"
            queryStatement = SQLiteHandler.queryNeedFinalize(database: db_nt, statement: statement)
            let bookNative = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
            SQLiteHandler.finalize(queryStatement: queryStatement)
            return bookNative
        }
        return nil
    }
    
    static func convertToEnglish(bookNative: String, ofVersion version: BibleVersion) -> String? {
        if let db_en = self.textDatabases[BibleVersion.KJV], let db_nt = self.textDatabases[version] {
            var statement = "SELECT id FROM books WHERE book = '\(bookNative)';"
            var queryStatement = SQLiteHandler.queryNeedFinalize(database: db_nt, statement: statement)
            let id = SQLiteHandler.integer(queryStatement: queryStatement, index: 0)
            SQLiteHandler.finalize(queryStatement: queryStatement)
            statement = "SELECT book FROM books WHERE id = \(id);"
            queryStatement = SQLiteHandler.queryNeedFinalize(database: db_en, statement: statement)
            let bookEnglish = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
            SQLiteHandler.finalize(queryStatement: queryStatement)
            return bookEnglish
        }
        return nil
    }
    
    static func books(version: BibleVersion) -> [String] {
        if let db = self.textDatabases[version] {
            let statement = "SELECT book FROM books;"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var arr: [String] = []
                repeat {
                    arr.append(SQLiteHandler.string(queryStatement: queryStatement, index: 0))
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return arr
            }
        }
        return []
    }
    
    static func book(id: Int, version: BibleVersion) -> String? {
        if let db = self.textDatabases[version] {
            let statement = "SELECT book FROM books WHERE id = \(id);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let book = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return book
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return nil
    }
    
}

