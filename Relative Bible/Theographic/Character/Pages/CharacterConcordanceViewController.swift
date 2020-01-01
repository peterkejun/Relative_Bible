//
//  CharacterConcordanceViewController.swift
//  Bible
//
//  Created by Peter Ke on 2019-10-14.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class CharacterConcordanceViewController: UIViewController {
    
    var attributes: [NSAttributedString.Key : Any] = [:]
    
    var character_id: Int = -1 {
        didSet {
            //concordance
            guard let osis_ref_string = BibleData.characterConcordanceString(id: self.character_id) else { return }
            let concordances = osis_ref_string.components(separatedBy: "///")
            for c in concordances {
                if let verse = self.verse(osisRef: c, version: ReadViewController.version) {
                    if verse.testament == .OldTestament {
                        self.concordance_old.append(verse)
                    } else {
                        self.concordance_new.append(verse)
                    }
                }
            }
            //attributes
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.firstLineHeadIndent = 34
            paragraphStyle.lineSpacing = 12
            self.attributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            //segmented control
            if !self.concordance_new.isEmpty && !self.concordance_old.isEmpty {
                self.concordance_segmented_control = UISegmentedControl.init(items: ["Old Testament", "New Testament"])
                self.concordance_segmented_control?.selectedSegmentIndex = 0
                if #available(iOS 13, *) {
                    
                } else {
                    self.concordance_segmented_control?.tintColor = UIColor.black.withAlphaComponent(0.7)
                }
                self.concordance_segmented_control?.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for: .valueChanged)
                self.view.addSubview(self.concordance_segmented_control!)
                self.concordance_segmented_control?.translatesAutoresizingMaskIntoConstraints = false
                self.concordance_segmented_control?.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
                self.concordance_segmented_control?.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
                self.concordance_segmented_control?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
                self.concordance_segmented_control?.heightAnchor.constraint(equalToConstant: 35).isActive = true
            }
            //table view
            self.table_view = UITableView.init()
            self.table_view.rowHeight = UITableView.automaticDimension
            self.table_view.estimatedRowHeight = 100
            self.table_view.delegate = self
            self.table_view.dataSource = self
            self.table_view.register(UINib.init(nibName: "BibleTextCell", bundle: nil), forCellReuseIdentifier: BibleTextCell.identifier)
            self.view.addSubview(self.table_view)
            self.table_view.translatesAutoresizingMaskIntoConstraints = false
            self.table_view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            self.table_view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            if let sc = self.concordance_segmented_control {
                self.table_view.topAnchor.constraint(equalTo: sc.bottomAnchor, constant: 10).isActive = true
            } else {
                self.table_view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            }
            self.table_view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            self.view.layoutIfNeeded()
            print("concordance for \(self.character_id)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }
    }
    
    var concordance_old: [Verse] = []
    var concordance_new: [Verse] = []
    
    var concordance_segmented_control: UISegmentedControl?
    
    var table_view: UITableView!

    func verse(osisRef: String, version: BibleVersion) -> Verse? {
        let components = osisRef.components(separatedBy: ".")
        guard let bookEnglish = CharacterConcordanceViewController.bookAcronym[components[0]], let chapter = Int(components[1]), let verseNumber = Int(components[2]), let content = BibleData.bibleText(book: bookEnglish, chapter: chapter, verseNumber: verseNumber, version: version) else { return nil }
        return Verse.init(book: bookEnglish, chapter: chapter, verseNumber: verseNumber, content: content, version: version)
    }
    
    func currentTestament() -> VerseTag.Testament? {
        let old_empty = self.concordance_old.isEmpty
        let new_empty = self.concordance_new.isEmpty
        if old_empty && new_empty {
            return nil
        } else if old_empty {
            return .NewTestament
        } else if new_empty {
            return .OldTestament
        } else if self.concordance_segmented_control?.selectedSegmentIndex == 0 {
            return .OldTestament
        } else if self.concordance_segmented_control?.selectedSegmentIndex == 1 {
            return .NewTestament
        } else {
            return nil
        }
    }

}

// MARK: - Segmented Control

extension CharacterConcordanceViewController {
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.table_view.reloadData()
    }
    
}

// MARK: - Table View Data Source

extension CharacterConcordanceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let testament = self.currentTestament()
        if testament == VerseTag.Testament.OldTestament {
            return self.concordance_old.count
        } else if testament == VerseTag.Testament.NewTestament {
            return self.concordance_new.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BibleTextCell.identifier, for: indexPath) as! BibleTextCell
        let testament = self.currentTestament()
        var text: String = "N/A"
        if testament == VerseTag.Testament.OldTestament {
            let verse = self.concordance_old[indexPath.section]
            text = BibleData.bibleText(book: verse.book, chapter: verse.chapter, verseNumber: verse.verseNum, version: ReadViewController.version) ?? "N/A"
        } else if testament == VerseTag.Testament.NewTestament {
            let verse = self.concordance_new[indexPath.section]
            text = BibleData.bibleText(book: verse.book, chapter: verse.chapter, verseNumber: verse.verseNum, version: ReadViewController.version) ?? "N/A"
        }
        cell.verseLabel.attributedText = NSAttributedString.init(string: text, attributes: self.attributes)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let testament = self.currentTestament()
        if testament == VerseTag.Testament.OldTestament {
            return self.concordance_old[section].tagDescription
        } else if testament == VerseTag.Testament.NewTestament {
            return self.concordance_new[section].tagDescription
        } else {
            return nil
        }
    }
    
}

// MARK: - Table View Delegate

extension CharacterConcordanceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

// MARK: - Data

extension CharacterConcordanceViewController {
    
    static let bookAcronym: [String: String] = [
        "Gen": "Genesis",
        "Exod": "Exodus",
        "Lev": "Leviticus",
        "Num": "Numbers",
        "Deut": "Deuteronomy",
        "Josh": "Joshua",
        "Judg": "Judges",
        "Ruth": "Ruth",
        "1Sam": "1 Samuel",
        "2Sam": "2 Samuel",
        "1Kgs": "1 Kings",
        "2Kgs": "2 Kings",
        "1Chr": "1 Chronicles",
        "2Chr": "2 Chronicles",
        "Ezra": "Ezra",
        "Neh": "Nehemiah",
        "Esth": "Esther",
        "Job": "Job",
        "Ps": "Psalms",
        "Prov": "Proverbs",
        "Eccl": "Ecclesiastes",
        "Song": "Song of Solomon",
        "Isa": "Isaiah",
        "Jer": "Jeremiah",
        "Lam": "Lamentations",
        "Ezek": "Ezekiel",
        "Dan": "Daniel",
        "Hos": "Hosea",
        "Joel": "Joel",
        "Amos": "Amos",
        "Obad": "Obadiah",
        "Jonah": "Jonah",
        "Mic": "Micah",
        "Nah": "Nahum",
        "Hab": "Habakkuk",
        "Zeph": "Zephaniah",
        "Hag": "Haggai",
        "Zech": "Zechariah",
        "Mal": "Malachi",
        "Matt": "Matthew",
        "Mark": "Mark",
        "Luke": "Luke",
        "John": "John",
        "Acts": "Acts",
        "Rom": "Romans",
        "1Cor": "1 Corinthians",
        "2Cor": "2 Corinthians",
        "Gal": "Galatians",
        "Eph": "Ephesians",
        "Phil": "Philippians",
        "Col": "Colossians",
        "1Thess": "1 Thessalonians",
        "2Thess": "2 Thessalonians",
        "1Tim": "1 Timothy",
        "2Tim": "2 Timothy",
        "Titus": "Titus",
        "Phlm": "Philemon",
        "Heb": "Hebrews",
        "Jas": "James",
        "1Pet": "1 Peter",
        "2Pet": "2 Peter",
        "1John": "1 John",
        "2John": "2 John",
        "3John": "3 John",
        "Jude": "Jude",
        "Rev": "Revelation",
    ]
    
}
