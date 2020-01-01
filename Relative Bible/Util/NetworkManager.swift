//
//  NetworkManager.swift
//  Bible
//
//  Created by Jun Ke on 8/23/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

class NetworkManager {
    
    enum DataType {
        case verseOfTheDay
        case todaysDevotional
    }
    
    static var verseOfTheDay: [String: Any]?
    static var todaysDevotional: [String: Any]?
    
    private static var votdSelector: Selector?
    private static var votdTarget: AnyObject?
    
    private static var tdSelector: Selector?
    private static var tdTarget: AnyObject?
    
    static func load() {
       Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
            print(self.verseOfTheDay == nil)
            if self.verseOfTheDay == nil {
                self.fetchVerseOfTheDay(regionCode: "en")
            } else {
                print("timer for verse of the day invalidated")
                timer.invalidate()
            }
        }
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
            if self.todaysDevotional == nil {
                self.fetchTodaysDevotional()
            } else {
                print("timer for today's devotional invalidated")
                timer.invalidate()
            }
        }
    }
    
    static func register(target: AnyObject, selector: Selector, dataType: DataType) {
        if dataType == .verseOfTheDay {
            self.votdTarget = target
            self.votdSelector = selector
        } else if dataType == .todaysDevotional {
            self.tdTarget = target
            self.tdSelector = selector
        }
    }
    
    static func fetchTodaysDevotional() {
        guard let url = URL.init(string: "https://raw.githubusercontent.com/pierrebeasley/HolyBibleData/master/TodaysDevotional.txt"), let source = try? String.init(contentsOf: url) else {
            self.todaysDevotional = nil
            return
        }
        let components = source.components(separatedBy: "]]]]]")
        let content = components[0]
        let title = components[1]
        let author = components[2]
        let aboutAuthor = components[3]
        let citation = components[4]
        self.todaysDevotional = [:]
        self.todaysDevotional?["title HTML"] = title
        self.todaysDevotional?["content HTML"] = content
        self.todaysDevotional?["author HTML"] = author
        self.todaysDevotional?["about author HTML"] = aboutAuthor
        self.todaysDevotional?["citation HTML"] = citation
        self.todaysDevotional?["date"] = Date.init()
        if let target = self.tdTarget, let selector = self.tdSelector {
            _ = target.perform(selector, with: self.todaysDevotional!)
        }
    }
    
    static func fetchVerseOfTheDay(regionCode: String) {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "dd_MM_yyyy"
        //print("https://raw.githubusercontent.com/pierrebeasley/HolyBibleData/master/\(regionCode)\(dateFormatter.string(from: Date.init())).txt")
        guard let url = URL.init(string: "https://raw.githubusercontent.com/pierrebeasley/HolyBibleData/master/\(regionCode)\(dateFormatter.string(from: Date.init())).txt"), let source = try? String.init(contentsOf: url) else {
            self.verseOfTheDay = nil
            return
        }
        var verseString: String!
        var thoughts: String!
        var prayer: String!
        let keys = source.components(separatedBy: "\n")
        for key in keys {
            if key.starts(with: "VERSE: ") {
                verseString = key.components(separatedBy: "VERSE: ")[1]
            } else if key.starts(with: "THOUGHTS: ") {
                thoughts = key.components(separatedBy: "THOUGHTS: ")[1]
            } else if key.starts(with: "PRAYER: ") {
                prayer = key.components(separatedBy: "PRAYER: ")[1]
            }
        }
        let verseComponents = verseString.components(separatedBy: " ")
        let book = verseComponents[0]
        var chapter = 0
        var verseN = 0
        if verseComponents[1].contains(":") {
            var numbersComponents = verseComponents[1].components(separatedBy: ":")
            chapter = Int(numbersComponents[0])!
            if numbersComponents[1].contains("-") {
                numbersComponents = numbersComponents[1].components(separatedBy: "-")
                verseN = Int(numbersComponents[0])!
            } else {
                verseN = Int(numbersComponents[1])!
            }
        } else {
            chapter = Int(verseComponents[1]) ?? 0
        }
        let verseTag = VerseTag.init(book: book, chapter: chapter, verseNumber: verseN)
        let imageName = "VerseOfTheDayImage\(dateFormatter.string(from: Date.init())).jpg"
        let imageDownloadPath = "https://raw.githubusercontent.com/pierrebeasley/VerseOfTheDay/master/" + imageName
        guard let imageURL = URL.init(string: imageDownloadPath) else {
            self.verseOfTheDay = nil
            return
        }
        self.verseOfTheDay = [:]
        self.verseOfTheDay?["tag"] = verseTag
        self.verseOfTheDay?["thoughts"] = thoughts
        self.verseOfTheDay?["prayer"] = prayer
        self.verseOfTheDay?["image URL"] = imageURL
        if let target = self.votdTarget, let selector = self.votdSelector {
            _ = target.perform(selector, with: self.verseOfTheDay!)
        }
    }
    
}

