//
//  BibleTextViewController.swift
//  Bible
//
//  Created by Jun Ke on 8/5/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class BibleTextViewController: UIViewController {
    
    static let apiKey = "6811b1c0dd04bd52c50a783cf7d55625"
    
    var tableView: UITableView!
    var tableViewLeadingConstraint: NSLayoutConstraint!
    var toolBar: UIToolbar!
    var searchBar: UISearchBar!
    var searchBarTopConstraint: NSLayoutConstraint!
    var searchTask: DispatchWorkItem?
    var selectionView: SidebarSelectionView!
    var selectionViewWidthConstraint: NSLayoutConstraint!
    var selectionViewDismissButton: UIButton?
    
    var previous_navbar_tint_color: UIColor?
    var previous_navbar_bar_tint_color: UIColor?
    var previous_tabbar_tint_color: UIColor?
    var previous_tabbar_bar_tint_color: UIColor?
    
    var searchBarItem: UIBarButtonItem!
    var infoBarItem: UIBarButtonItem!
    var bookToolBarItem: UIBarButtonItem!
    var versionToolBarItem: UIBarButtonItem!
    var previousToolBarItem: UIBarButtonItem!
    var nextToolBarItem: UIBarButtonItem!
    
    var popupView: VersePopupView?
    var popupViewBottomConstraint: NSLayoutConstraint?
    var popupDismissButton: UIButton?
    
    var minimizeButton: UIButton!
    
    var book: String = "Genesis"
    var chapter: Int = 1
    var concordance: [[String]] = []
    
    var theme: TextOptionsViewController.Theme = .classic
    
    var fontSize: CGFloat = 17 {
        willSet {
            if self.fontSize != newValue {
                self.verses = self.fetchText(book: self.book, chapter: self.chapter, version: ReadViewController.version, size: newValue)
                self.tableView.reloadData()
            }
        }
    }
    
    var verses: [NSMutableAttributedString] = []
    
    var indexPathToShowAtVisible: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        
        self.previous_navbar_tint_color = self.navigationController?.navigationBar.tintColor
        self.previous_navbar_bar_tint_color = self.navigationController?.navigationBar.barTintColor
        self.previous_tabbar_tint_color = self.tabBarController?.tabBar.tintColor
        self.previous_tabbar_bar_tint_color = self.tabBarController?.tabBar.barTintColor
        
        let savedTheme = userDefaults.integer(forKey: "reading theme")
        if savedTheme == 0 {
            self.theme = .classic
        } else {
            self.theme = TextOptionsViewController.Theme.init(rawValue: savedTheme - 1) ?? .classic
        }
        
        // Do any additional setup after loading the view.        
        self.view.backgroundColor = UIColor.white
        self.layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isMovingToParent {
            self.verses = self.fetchText(book: self.book, chapter: self.chapter, version: ReadViewController.version)
            tableView.reloadData()
            self.updateToolBar()
            self.searchBar.placeholder = "Search in \(self.book)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isMovingToParent {
            if let indexPath = self.indexPathToShowAtVisible {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.navigationController?.navigationBar.barTintColor = self.previous_navbar_bar_tint_color
            self.navigationController?.navigationBar.tintColor = self.previous_navbar_tint_color
            self.tabBarController?.tabBar.barTintColor = self.previous_tabbar_bar_tint_color
            self.tabBarController?.tabBar.tintColor = self.previous_tabbar_tint_color
            BibleTextCell.textColor = UIColor.black
            if let firstVisibleIndexPath = self.tableView.indexPathsForVisibleRows?.first {
                let verseTag = VerseTag.init(book: self.book, chapter: self.chapter, verseNumber: firstVisibleIndexPath.row + 1)
                ReadViewController.leftOff = verseTag
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 12.0, *) {
            let user_interface_style = self.traitCollection.userInterfaceStyle
            if user_interface_style == .dark {
                self.theme = .dark
            }
        }
    }
    
    func updateToolBar() {
        if let bookNative = BibleData.convertToNative(bookEnglish: self.book, toVersion: ReadViewController.version) {
            self.bookToolBarItem.title = bookNative + " \(self.chapter)"
        }
        self.versionToolBarItem.title = ReadViewController.version.rawValue
    }
    
    func nextChapter(current: Int) -> Int {
        guard let count = BibleData.numChaptersDict[self.book] else { return -1 }
        if current + 1 <= count {
            return current + 1
        } else {
            return -1
        }
    }
    
    func previousChapter(current: Int) -> Int {
        if current - 1 > 0 {
            return current - 1
        } else {
            return -1
        }
    }
    
    func fetchText(book: String, chapter: Int, version: BibleVersion, size: CGFloat = BibleTextViewController.defaultFontSize) -> [NSMutableAttributedString] {
        guard let lines = BibleData.bibleText(book: book, chapter: chapter, version: version) else {
            return []
        }
        return self.convertRawToAttributed(lines, fontSize: size)
    }
    
    func convertRawToAttributed(_ texts: [String], fontSize size: CGFloat) -> [NSMutableAttributedString] {
        var verses: [NSMutableAttributedString] = []
        
        let numAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor.lightGray,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: size - 2, weight: .light)
        ]
        let verseAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: size, weight: .regular)
        ]
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 18
        paragraphStyle.firstLineHeadIndent = 20
        
        for (n, line) in texts.enumerated() {
            let numStr = NSMutableAttributedString.init(string: "\(n + 1) ", attributes: numAttributes)
            let contentStr = NSMutableAttributedString.init(string: line, attributes: verseAttributes)
            self.setHighlight(contentStr, color: UserData.highlightColor(book: self.book, chapter: self.chapter, verse: n + 1))
//            self.setUnderline(contentStr, occurences: self.concordance[n])
            numStr.append(contentStr)
            numStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: numStr.length))
            verses.append(numStr)
        }
        return verses
    }
    
    func setUnderline(_ mutableAttributedString: NSMutableAttributedString, occurences: [String]) {
        if occurences.isEmpty {
            let fullRange = NSRange.init(location: 0, length: mutableAttributedString.length)
            mutableAttributedString.removeAttribute(.underlineStyle, range: fullRange)
            mutableAttributedString.removeAttribute(.underlineColor, range: fullRange)
            return
        }
        for occurence in occurences {
            let range = (mutableAttributedString.string as NSString).range(of: occurence)
            mutableAttributedString.addAttributes([
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.patternDot.union(.thick).rawValue,
                NSAttributedString.Key.underlineColor : BibleTextCell.textColor
            ], range: range)
        }
    }
    
    func setHighlight(_ mutableAttributedString: NSMutableAttributedString, color: UIColor?) {
        let fullRange = NSRange.init(location: 0, length: mutableAttributedString.length)
        mutableAttributedString.removeAttribute(.backgroundColor, range: fullRange)
        if let c = color {
            mutableAttributedString.addAttribute(.backgroundColor, value: c.withAlphaComponent(0.5), range: fullRange)
        }
    }
    
    func setHighlight(cell: BibleTextCell, color: UIColor?) {
        guard let attributedText = cell.verseLabel.attributedText else { return }
        let mutableAttributedText = NSMutableAttributedString.init(attributedString: attributedText)
        let fullRange = NSRange.init(location: 0, length: attributedText.length)
        mutableAttributedText.removeAttribute(.backgroundColor, range: fullRange)
        if let c = color {
            mutableAttributedText.addAttribute(.backgroundColor, value: c.withAlphaComponent(0.5), range: fullRange)
        }
        cell.verseLabel.attributedText = mutableAttributedText
    }
    
    func rangeOfLeadingNumber(text: String) -> NSRange {
        if Int(text.prefix(3)) != nil {
            return NSRange.init(location: 0, length: 3)
        } else if Int(text.prefix(2)) != nil {
            return NSRange.init(location: 0, length: 2)
        } else if Int(text.prefix(1)) != nil {
            return NSRange.init(location: 0, length: 1)
        } else {
            return NSRange.init(location: 0, length: 0)
        }
    }
    
    static var defaultFontSize: CGFloat {
        return 17
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BibleTextViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

