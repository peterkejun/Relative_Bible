//
//  BibleTextVC+TableView.swift
//  Bible
//
//  Created by Jun Ke on 8/6/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension BibleTextViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.verses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BibleTextCell.identifier, for: indexPath) as! BibleTextCell
        cell.verseLabel.attributedText = self.verses[indexPath.row]
        cell.verseLabel.textColor = BibleTextCell.textColor
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let content = BibleData.bibleText(book: self.book, chapter: self.chapter, verseNumber: indexPath.row + 1, version: ReadViewController.version) {
            self.showPopup(verse: Verse.init(book: self.book, chapter: self.chapter, verseNumber: indexPath.row + 1, content: content, version: ReadViewController.version))
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            self.minimizeButton.alpha = 1.0
        } else {
            self.minimizeButton.alpha = 0.5
        }
    }
    
}


