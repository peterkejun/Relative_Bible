//
//  Verse.swift
//  Bible
//
//  Created by Jun Ke on 8/6/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class VerseTag {
    
    var book: String = "Genesis"
    var chapter: Int = 1
    var verseNum: Int = 1
    var testament: Testament = .NewTestament
    
    init(book: String, chapter: Int, verseNumber: Int) {
        self.book = book
        self.chapter = chapter
        self.verseNum = verseNumber
        self.testament = BibleData.testament(bookEnglish: self.book)
    }
    
    init(storageString: String) {
        let components = storageString.components(separatedBy: "///")
        self.book = components[0]
        self.chapter = Int(components[1])!
        self.verseNum = Int(components[2])!
        self.testament = BibleData.testament(bookEnglish: self.book)
    }
    
    init?(description: String) {
        var components = description.components(separatedBy: ":")
        if let verseNum = Int(components[1]) {
            self.verseNum = verseNum
        } else {
            return nil
        }
        components = components[0].components(separatedBy: " ")
        if let chapterString = components.last, let chapter = Int(chapterString) {
            self.chapter = chapter
        } else {
            return nil
        }
        self.book = components.dropLast().joined()
        self.testament = BibleData.testament(bookEnglish: self.book)
    }
    
    var description: String {
        return self.book + " \(self.chapter):\(self.verseNum)"
    }
    
    var storageString: String {
        return "\(self.book)///\(self.chapter)///\(self.verseNum)"
    }
    
    func translatedDescription(ofVersion version: BibleVersion) -> String {
        if let bookNative = BibleData.convertToNative(bookEnglish: self.book, toVersion: version) {
            return bookNative + " \(self.chapter):\(self.verseNum)"
        } else {
            return self.description
        }
    }
    
    func compare(_ other: VerseTag) -> ComparisonResult? {
        if self == other {
            return .orderedSame
        }
        guard let index1 = BibleData.books(version: .KJV).firstIndex(of: self.book),
            let index2 = BibleData.books(version: .KJV).firstIndex(of: other.book)
            else {
                return nil
        }
        if index1 == index2 {
            let chapterResult = self.chapter.compare(other.chapter)
            if chapterResult == .orderedSame {
                return self.verseNum.compare(other.verseNum)
            } else {
                return chapterResult
            }
        } else if index1 > index2 {
            return .orderedDescending
        } else {
            return .orderedAscending
        }
    }
    
    static func ==(lhs: VerseTag, rhs: VerseTag) -> Bool {
        return lhs.book == rhs.book
            && lhs.chapter == rhs.chapter
            && lhs.verseNum == rhs.verseNum
    }
    
    enum Testament {
        case OldTestament
        case NewTestament
    }
    
}


