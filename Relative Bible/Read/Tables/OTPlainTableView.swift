//
//  OTPlainTableView.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class OTPlainTableView: UITableView, UITableViewDataSource {
    
    let books = BibleData.OldTestamentNames
    var booksAlphabetical: [String] = []
    
    var mode: Mode = .original {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        if #available(iOS 13, *) {
            self.backgroundColor = UIColor.systemGray6
        } else {
            self.backgroundColor = UIColor.white
        }
        self.dataSource = self
        self.booksAlphabetical = books.sorted(by: <)
        self.register(UINib.init(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: BookTableViewCell.identifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BibleData.numBooksOldTestament
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as! BookTableViewCell
        let bookEnglish = mode == .original ? books[indexPath.row] : booksAlphabetical[indexPath.row]
        let bookNative = BibleData.convertToNative(bookEnglish: bookEnglish, toVersion: ReadViewController.version)
        cell.nameLabel.text = bookNative
        cell.numberLabel.text = "\(BibleData.numChaptersDict[bookEnglish]!) ch."
        cell.accessoryType = .disclosureIndicator
        if #available(iOS 13, *) {
            cell.backgroundColor = UIColor.systemGray6
        }
        return cell
    }
    
    enum Mode {
        case original
        case alphabetical
    }
    
}
