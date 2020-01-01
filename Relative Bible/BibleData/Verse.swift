//
//  Verse.swift
//  Bible
//
//  Created by Jun Ke on 8/6/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class Verse: VerseTag {
    
    var content: String = "In the beginning God created the heaven and the earth."
    var version: BibleVersion = .KJV
    
    init(book: String, chapter: Int, verseNumber: Int, content: String, version: BibleVersion = BibleVersion.KJV) {
        super.init(book: book, chapter: chapter, verseNumber: verseNumber)
        self.content = content
        self.version = version
    }
    
    override var description: String {
        return super.description + " " + self.content
    }
    
    var tagDescription: String {
        return super.description
    }
    
}

