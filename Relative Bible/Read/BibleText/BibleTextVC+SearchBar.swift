//
//  BibleTextVC+SearchBar.swift
//  Bible
//
//  Created by Jun Ke on 8/6/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension BibleTextViewController: UISearchBarDelegate {
    
    var searchBarAnimationDuration: Double {
        return 0.2
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarButtonPressed(self.searchBarItem)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTask?.cancel()
        let task = DispatchWorkItem.init { [weak self] in
            self?.executeSearch(text: searchText)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: task)
    }
    
    func executeSearch(text: String) {
        if text.isEmpty || text.rangeOfCharacter(from: CharacterSet.alphanumerics) == nil {
            return
        }
        let versesRaw = BibleData.bibleText(contains: text, inBook: self.book, chapter: self.chapter, version: ReadViewController.version).map { $0.content }
        self.verses = self.convertRawToAttributed(versesRaw, fontSize: self.fontSize)
        self.tableView.reloadData()
    }
    
}

