//
//  NTDivisionTableView.swift
//  Bible
//
//  Created by Jun Ke on 8/1/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class NTDivisionTableView: UITableView, UITableViewDataSource {
    
    let divisions = Array(BibleData.divisionsNew)
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        if #available(iOS 13, *) {
            self.backgroundColor = UIColor.systemGray6
        } else {
            self.backgroundColor = UIColor.white
        }
        self.dataSource = self
        self.register(UINib.init(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: BookTableViewCell.identifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return 9
        case 3:
            return 1
        case 4:
            return 4
        case 5:
            return 7
        case 6:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as! BookTableViewCell
        let division = divisions[indexPath.section]
        let bookEnglish = BibleData.divisionBooks[division]![indexPath.row]
        let bookNative = BibleData.convertToNative(bookEnglish: bookEnglish, toVersion: ReadViewController.version)
        cell.nameLabel.text = bookNative
        cell.numberLabel.text = "\(BibleData.numChaptersDict[bookEnglish]!) ch."
        cell.accessoryType = .disclosureIndicator
        if #available(iOS 13, *) {
            cell.backgroundColor = UIColor.systemGray6
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return divisions[section]
    }
    
}
