//
//  ChapterSelectionView.swift
//  Bible
//
//  Created by Jun Ke on 8/7/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol SidebarSelectionViewDelegate: class {
    func sidebarSelectionView(_ sidebarSelectionView: SidebarSelectionView, didSelectChapter chapter: Int)
    func sidebarSelectionView(_ sidebarSelectionView: SidebarSelectionView, didSelectVersion version: BibleVersion)
}

class SidebarSelectionView: UIView {
    
    enum Mode {
        case chapter
        case version
    }
    
    private(set) var mode: Mode = .chapter
    
    weak var delegate: SidebarSelectionViewDelegate?
    
    var tableView: UITableView!
    
    var accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
    
    var book: String = "Genesis"
    
    init(frame: CGRect, book: String) {
        super.init(frame: frame)
        self.book = book
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.tableView = UITableView.init()
        self.tableView.separatorColor = UIColor.init(white: 1, alpha: 0.5)
        self.tableView.backgroundColor = UIColor.init(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setMode(_ newMode: Mode) {
        self.mode = newMode
        self.tableView.reloadData()
    }
    
}

extension SidebarSelectionView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mode == .chapter {
            return BibleData.numChaptersDict[self.book] ?? 0
        } else {
            return bibleVersionLiteral.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        if self.mode == .chapter, let bookNative = BibleData.convertToNative(bookEnglish: self.book, toVersion: ReadViewController.version) {
            cell.textLabel?.text = bookNative + " \(indexPath.row + 1)"
        } else {
            cell.textLabel?.text = bibleVersionLiteralNative[BibleVersion.all[indexPath.row]]
            cell.detailTextLabel?.text = bibleVersionLiteral[BibleVersion.all[indexPath.row]]
        }
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.init(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
        cell.accessoryType = self.accessoryType
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.mode == .chapter ? "Select chapter" : "Select version"
    }
    
}

extension SidebarSelectionView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.mode == .chapter {
            self.delegate?.sidebarSelectionView(self, didSelectChapter: indexPath.row + 1)
        } else {
            self.delegate?.sidebarSelectionView(self, didSelectVersion: BibleVersion.all[indexPath.row])
        }
    }
    
}

