//
//  UserData+Highlight.swift
//  Bible
//
//  Created by Jun Ke on 8/22/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension UserData {
    
    static var highlights: [(VerseTag, String, Date)] {
        if let db = self.database {
            let statement = "SELECT * FROM Highlight;"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                var arr: [(VerseTag, String, Date)] = []
                repeat {
                    let book = SQLiteHandler.string(queryStatement: queryStatement, index: 1)
                    let chapter = SQLiteHandler.integer(queryStatement: queryStatement, index: 2)
                    let verseNumber = SQLiteHandler.integer(queryStatement: queryStatement, index: 3)
                    let colorHex = SQLiteHandler.string(queryStatement: queryStatement, index: 4).uppercased()
                    let dateString = SQLiteHandler.string(queryStatement: queryStatement, index: 5)
                    var date = Date.init()
                    if let secondsSince1970 = TimeInterval(dateString) {
                        date = Date.init(timeIntervalSince1970: secondsSince1970)
                    }
                    arr.append((VerseTag.init(book: book, chapter: chapter, verseNumber: verseNumber), colorHex, date))
                } while SQLiteHandler.stepQueryStatement(queryStatement)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return arr
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return []
    }
    
    static func highlightColor(book: String, chapter: Int, verse: Int) -> UIColor? {
        if let db = self.database {
            let statement = "SELECT colorHex FROM Highlight WHERE book = '\(book)' AND chapter = \(chapter) AND verse = \(verse);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let hex = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                return UIColor.init(hex: hex)
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return nil
    }
    
    static func highlightDate(book: String, chapter: Int, verse: Int) -> Date? {
        if let db = self.database {
            let statement = "SELECT date FROM Highlight WHERE book = '\(book)' AND chapter = \(chapter) AND verse = \(verse);"
            let queryStatement = SQLiteHandler.queryNeedFinalize(database: db, statement: statement)
            if queryStatement != nil {
                let dateString = SQLiteHandler.string(queryStatement: queryStatement, index: 0)
                SQLiteHandler.finalize(queryStatement: queryStatement)
                if let secondsSince1970 = TimeInterval(dateString) {
                    return Date.init(timeIntervalSince1970: secondsSince1970)
                } else {
                    return nil
                }
            }
            SQLiteHandler.finalize(queryStatement: queryStatement)
        }
        return nil
    }
    
    static func setHighlightColor(book: String, chapter: Int, verse: Int, colorHex: String?, date: Date) {
        guard let db = self.database else { return }
        if let hex = colorHex {
            if SQLiteHandler.containsEntry(db: db, tableName: "Highlight", fields: ["book", "chapter", "verse"], values: [book as NSString, NSNumber.init(value: chapter) as NSObject, NSNumber.init(value: verse) as NSObject], types: [.TEXT, .INTEGER, .INTEGER]) {
                let statement = "UPDATE Highlight SET colorHex = '\(hex)', date = '\(date.timeIntervalSince1970)' WHERE book = '\(book)' AND chapter = \(chapter) AND verse = \(verse);"
                SQLiteHandler.update(db: db, statement: statement)
            } else {
                SQLiteHandler.insert(db: db, tableName: "Highlight", fields: ["book", "chapter", "verse", "colorHex", "date"], values: [book as NSString, NSNumber.init(value: chapter) as NSObject, NSNumber.init(value: verse) as NSObject, hex as NSString, String(date.timeIntervalSince1970) as NSString], types: [.TEXT, .INTEGER, .INTEGER, .TEXT, .TEXT])
            }
        } else {
            SQLiteHandler.deleteAllOccurrences(db: db, tableName: "Highlight", fields: ["book", "chapter", "verse"], values: [book as NSString, NSNumber.init(value: chapter) as NSObject, NSNumber.init(value: verse) as NSObject], types: [.TEXT, .INTEGER, .INTEGER])
        }
    }
    
    static func setHighlightColor(book: String, chapter: Int, verse: Int, color: UIColor?, date: Date) {
        self.setHighlightColor(book: book, chapter: chapter, verse: verse, colorHex: color?.hexString, date: date)
    }
    
}

