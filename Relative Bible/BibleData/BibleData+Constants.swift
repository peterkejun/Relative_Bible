//
//  BibleData+Constants.swift
//  Bible
//
//  Created by Jun Ke on 8/4/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

extension BibleData {
    
    static var bookOsisRefs: [String: String] {
        return [
            "Genesis": "Gen",
            "Exodus": "Exod",
            "Leviticus": "Lev",
            "Numbers": "Num",
            "Deuteronomy": "Deut",
            "Joshua": "Josh",
            "Judges": "Judg",
            "Ruth": "Ruth",
            "1 Samuel": "1Sam",
            "2 Samuel": "2Sam",
            "1 Kings": "1Kgs",
            "2 Kings": "2Kgs",
            "1 Chronicles": "1Chr",
            "2 Chronicles": "2Chr",
            "Ezra": "Ezra",
            "Nehemiah": "Neh",
            "Esther": "Esth",
            "Job": "Job",
            "Psalms": "Ps",
            "Proverbs": "Prov",
            "Ecclesiastes": "Eccl",
            "Song of Solomon": "Song",
            "Isaiah": "Isa",
            "Jeremiah": "Jer",
            "Lamentations": "Lam",
            "Ezekiel": "Ezek",
            "Daniel": "Dan",
            "Hosea": "Hos",
            "Joel": "Joel",
            "Amos": "Amos",
            "Obadiah": "Obad",
            "Jonah": "Jonah",
            "Micah": "Mic",
            "Nahum": "Nah",
            "Habakkuk": "Hab",
            "Zephaniah": "Zeph",
            "Haggai": "Hag",
            "Zechariah": "Zech",
            "Malachi": "Mal",
            "Matthew": "Matt",
            "Mark": "Mark",
            "Luke": "Luke",
            "John": "John",
            "Acts": "Acts",
            "Romans": "Rom",
            "1 Corinthians": "1Cor",
            "2 Corinthians": "2Cor",
            "Galatians": "Gal",
            "Ephesians": "Eph",
            "Philippians": "Phil",
            "Colossians": "Col",
            "1 Thessalonians": "1Thess",
            "2 Thessalonians": "2Thess",
            "1 Timothy": "1Tim",
            "2 Timothy": "2Tim",
            "Titus": "Titus",
            "Philemon": "Phlm",
            "Hebrews": "Heb",
            "James": "Jas",
            "1 Peter": "1Pet",
            "2 Peter": "2Pet",
            "1 John": "1John",
            "2 John": "2John",
            "3 John": "3John",
            "Jude": "Jude",
            "Revelation": "Rev"
        ]
    }
    
    static let numBooksOldTestament: Int = 39
    static let numBooksNewTestament: Int = 27
    
    static var OldTestamentNames: ArraySlice<String> {
        return wholeBibleNames[0...38]
    }
    static var NewTestamentNames: ArraySlice<String> {
        return wholeBibleNames[39...65]
    }
    static let wholeBibleNames: [String] = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi", "Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
    
    static var divisions: [String] {
        return ["Law", "Former Prophets", "Major Prophets", "Minor Prophets", "Wisdom", "Festival Scrolls", "Revelation (OT)", "Gospels", "Acts", "To The Churches", "To The Hebrews", "To The Brothers", "General Epistles", "Revelation (NT)"]
    }
    
    static func division(book: String) -> String? {
        for (key, value) in divisionBooks {
            if value.contains(book) {
                return key
            }
        }
        return nil
    }
    
    static var divisionsNew: ArraySlice<String> {
        return divisions[7...13]
    }
    
    static var divisionsOld: ArraySlice<String> {
        return divisions[0...6]
    }
    
    static var divisionBooks: [String: [String]] {
        return [
            "Law": ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy"],
            "Former Prophets": ["Joshua", "Judges", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings"],
            "Major Prophets": ["Isaiah", "Jeremiah", "Ezekiel"],
            "Minor Prophets": ["Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"],
            "Wisdom": ["Psalms", "Proverbs", "Job"],
            "Festival Scrolls": ["Song of Solomon", "Ruth", "Lamentations", "Ecclesiastes", "Esther"],
            "Revelation (OT)": ["Daniel", "Ezra", "Nehemiah", "1 Chronicles", "2 Chronicles"],
            "Gospels": ["Matthew", "Mark", "Luke", "John"],
            "Acts": ["Acts"],
            "To The Churches": ["Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians"],
            "To The Hebrews": ["Hebrews"],
            "To The Brothers": ["1 Timothy", "2 Timothy", "Titus", "Philemon"],
            "General Epistles": ["James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude"],
            "Revelation (NT)": ["Revelation"]
        ]
    }
    
    static var booksOrderedByDivision: [String] {
        var arr: [String] = []
        for division in divisions {
            for books in divisionBooks[division]! {
                arr.append(books)
            }
        }
        return arr
    }
    
    static func divisionIndex(index: Int) -> Int {
        switch index {
        case 0..<5:
            return 0
        case 5..<11:
            return 1
        case 11..<14:
            return 2
        case 14..<26:
            return 3
        case 26..<29:
            return 4
        case 29..<34:
            return 5
        case 34..<39:
            return 6
        default:
            return -1
        }
    }
    
    static func division(index: Int) -> String {
        let i = divisionIndex(index: index)
        if i == -1 {
            return "not found"
        } else {
            return divisions[i]
        }
    }
    
    static let numChaptersDict: [String: Int] = [
        "Genesis": 50,
        "Exodus": 40,
        "Leviticus": 27,
        "Numbers": 36,
        "Deuteronomy": 34,
        "Joshua": 24,
        "Judges": 21,
        "Ruth": 4,
        "1 Samuel": 31,
        "2 Samuel": 24,
        "1 Kings": 22,
        "2 Kings": 25,
        "1 Chronicles": 29,
        "2 Chronicles": 36,
        "Ezra": 10,
        "Nehemiah": 13,
        "Esther": 10,
        "Job": 42,
        "Psalms": 150,
        "Proverbs": 31,
        "Ecclesiastes": 12,
        "Song of Solomon": 8,
        "Isaiah": 66,
        "Jeremiah": 52,
        "Lamentations": 5,
        "Ezekiel": 48,
        "Daniel": 12,
        "Hosea": 14,
        "Joel": 3,
        "Amos": 9,
        "Obadiah": 1,
        "Jonah": 4,
        "Micah": 7,
        "Nahum": 3,
        "Habakkuk": 3,
        "Zephaniah": 3,
        "Haggai": 2,
        "Zechariah": 14,
        "Malachi": 4,
        "Matthew": 28,
        "Mark": 16,
        "Luke": 24,
        "John": 21,
        "Acts": 28,
        "Romans": 16,
        "1 Corinthians": 16,
        "2 Corinthians": 13,
        "Galatians": 6,
        "Ephesians": 6,
        "Philippians": 4,
        "Colossians": 4,
        "1 Thessalonians": 5,
        "2 Thessalonians": 3,
        "1 Timothy": 6,
        "2 Timothy": 4,
        "Titus": 3,
        "Philemon": 1,
        "Hebrews": 13,
        "James": 5,
        "1 Peter": 5,
        "2 Peter": 3,
        "1 John": 5,
        "2 John": 1,
        "3 John": 1,
        "Jude": 1,
        "Revelation": 22
    ]
    
}

