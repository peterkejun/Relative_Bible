//
//  ReadVC+Search.swift
//  Bible
//
//  Created by Jun Ke on 9/16/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension ReadViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchTask?.cancel()
        self.searchBarButtonPressed(self.searchBarButtonItem)
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
            self.searchFiltered = BibleData.wholeBibleNames
            self.searchTableView?.reloadData()
            return
        }
        self.searchFiltered = BibleData.wholeBibleNames.filter({ (book) -> Bool in
            return book.starts(with: text)
        })
        self.searchTableView?.reloadData()
    }
    
}

