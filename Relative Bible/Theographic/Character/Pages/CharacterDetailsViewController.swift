//
//  CharacterDetailsViewController.swift
//  Bible
//
//  Created by Jun Ke on 9/21/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    var osisRefControl: JKSegmentedControl!
    var collectionViewLayout: CharacterConcordanceLayout!
    var collectionView: UICollectionView!
    
    var numberOfConcordance: Int = -1
    var concordanceNew: [Verse] = []
    var concordanceOld: [Verse] = []
    
    var characterID: Int = -1 {
        didSet {
            guard let info = BibleData.characterInfo(id: self.characterID) else { return }
            let scrollView = UIScrollView.init()
            self.view.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            var previousView: UIView? = nil
            //concordance
            if let osisRefString = info.osisRefString {
                let label = UILabel.init()
                label.text = "biblical concordance"
                label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                label.textColor = UIColor.init(hex: "CFCFD3")
                scrollView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 33).isActive = true
                if previousView == nil {
                    label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 22).isActive = true
                } else {
                    label.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 22).isActive = true
                }
                
                self.osisRefControl = JKSegmentedControl.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width - 38, height: JKSegmentedControl.standardHeight), items: ["Old Testament", "New Testament"])
                self.osisRefControl.addTarget(self, action: #selector(self.osisRefControlValueChanged))
                scrollView.addSubview(self.osisRefControl)
                self.osisRefControl.translatesAutoresizingMaskIntoConstraints = false
                self.osisRefControl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 18).isActive = true
                self.osisRefControl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -18).isActive = true
                self.osisRefControl.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
                self.osisRefControl.heightAnchor.constraint(equalToConstant: self.osisRefControl.bounds.height).isActive = true
                previousView = self.osisRefControl
                
                let concordances = osisRefString.components(separatedBy: "///")
                for c in concordances {
                    if let verse = self.verse(osisRef: c, version: ReadViewController.version) {
                        if verse.testament == .OldTestament {
                            self.concordanceOld.append(verse)
                        } else {
                            self.concordanceNew.append(verse)
                        }
                    }
                }
                self.numberOfConcordance = self.concordanceOld.count
                
                self.collectionViewLayout = CharacterConcordanceLayout.init()
                self.collectionViewLayout.delegate = self
                self.collectionView = UICollectionView.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: 120), collectionViewLayout: self.collectionViewLayout)
                self.collectionView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
                self.collectionView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.indicatorStyle = .white
                self.collectionView.register(UINib.init(nibName: "VerseRefCell", bundle: nil), forCellWithReuseIdentifier: VerseRefCell.identifier)
                scrollView.addSubview(self.collectionView)
                self.collectionView.translatesAutoresizingMaskIntoConstraints = false
                self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
                self.collectionView.topAnchor.constraint(equalTo: self.osisRefControl.bottomAnchor, constant: 15).isActive = true
                self.collectionView.heightAnchor.constraint(equalToConstant: 275).isActive = true
                previousView = self.collectionView
            }
            //description
            if let description = info.description {
                let label = UILabel.init()
                label.text = "description"
                label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                label.textColor = UIColor.init(hex: "CFCFD3")
                scrollView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                if previousView == nil {
                    label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 22).isActive = true
                } else {
                    label.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 22).isActive = true
                }
                label.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
                previousView = label
                let sentences = description.replacingOccurrences(of: "\n", with: "").components(separatedBy: ". ")
                let paragraphStyle = NSMutableParagraphStyle.init()
                paragraphStyle.lineSpacing = 12
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7),
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
                for sentence in sentences {
                    let pointLabel = UILabel.init()
                    pointLabel.text = "-"
                    pointLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
                    pointLabel.textColor = UIColor.black.withAlphaComponent(0.7)
                    scrollView.addSubview(pointLabel)
                    pointLabel.translatesAutoresizingMaskIntoConstraints = false
                    pointLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40).isActive = true
                    if previousView == label {
                        pointLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
                    } else {
                        pointLabel.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 3).isActive = true
                    }
                    let sentenceLabel = UILabel.init()
                    sentenceLabel.attributedText = NSAttributedString.init(string: sentence.appending("."), attributes: attributes)
                    sentenceLabel.numberOfLines = 0
                    scrollView.addSubview(sentenceLabel)
                    sentenceLabel.translatesAutoresizingMaskIntoConstraints = false
                    sentenceLabel.leadingAnchor.constraint(equalTo: pointLabel.trailingAnchor, constant: 6).isActive = true
                    sentenceLabel.firstBaselineAnchor.constraint(equalTo: pointLabel.firstBaselineAnchor).isActive = true
                    sentenceLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
                    previousView = sentenceLabel
                }
            }
            
            self.view.layoutIfNeeded()
            scrollView.contentSize = CGSize.init(width: scrollView.bounds.width, height: previousView!.frame.maxY + 15)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func osisRefControlValueChanged() {
        if self.osisRefControl.selectedIndex == 0 {
            self.numberOfConcordance = self.concordanceOld.count
        } else {
            self.numberOfConcordance = self.concordanceNew.count
        }
        self.collectionViewLayout.prepare()
        self.collectionView.reloadData()
    }
    
    func verse(osisRef: String, version: BibleVersion) -> Verse? {
        let components = osisRef.components(separatedBy: ".")
        guard let bookEnglish = bookAcronym[components[0]], let chapter = Int(components[1]), let verseNumber = Int(components[2]), let content = BibleData.bibleText(book: bookEnglish, chapter: chapter, verseNumber: verseNumber, version: version) else { return nil }
        return Verse.init(book: bookEnglish, chapter: chapter, verseNumber: verseNumber, content: content, version: version)
    }
    
    let bookAcronym: [String: String] = [
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CharacterDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfConcordance
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerseRefCell.identifier, for: indexPath) as! VerseRefCell
        let verse = self.osisRefControl.selectedIndex == 0 ? self.concordanceOld[indexPath.item] : self.concordanceNew[indexPath.item]
        cell.bookLabel.text = verse.book
        cell.verseLabel.text = "\(verse.chapter):\(verse.verseNum)"
        cell.contentLabel.text = verse.content
        return cell
    }
    
}

extension CharacterDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension CharacterDetailsViewController: CharacterConcordanceLayoutDelegate {
    
    func concordanceCollectionView(_ collectionView: UICollectionView, widthForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        return self.cellSize.width
    }
    
    func concordanceCollectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        return self.cellSize.height
    }
    
    var cellSize: CGSize {
        return .init(width: 99, height: 128)
    }
    
}

