//
//  ReadVC+TableView.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension ReadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BookTableViewCell, let book = cell.nameLabel.text, let bookEnglish = BibleData.convertToEnglish(bookNative: book, ofVersion: ReadViewController.version) else {
            return
        }
        let bibleTextVC = BibleTextViewController.init()
        bibleTextVC.book = bookEnglish
        if tableView == self.searchTableView {
            self.searchBar.resignFirstResponder()
            self.searchTableView?.removeFromSuperview()
            self.searchTableView = nil
            self.searchBarBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(bibleTextVC, animated: true)
    }
    
    //search table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as! BookTableViewCell
        let bookEnglish = searchFiltered[indexPath.row]
        let bookNative = BibleData.convertToNative(bookEnglish: bookEnglish, toVersion: ReadViewController.version)
        cell.nameLabel.text = bookNative
        cell.numberLabel.text = "\(BibleData.numChaptersDict[bookEnglish]!) ch."
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}

