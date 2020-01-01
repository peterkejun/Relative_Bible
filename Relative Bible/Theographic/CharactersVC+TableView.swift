//
//  CharactersVC+TableView.swift
//  Bible
//
//  Created by Jun Ke on 9/17/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.search_active {
            //search active
            return 1
        }
        return self.initials.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.search_active {
            //search active
            return self.search_filtered.count
        }
        let initial = self.initials[section]
        return self.charactersOfInitial[initial]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if self.search_active {
            //search active
            let id = self.search_filtered[indexPath.row]
            cell.textLabel?.text = BibleData.characterName(id: id)
        } else {
            let initial = self.initials[indexPath.section]
            let id = self.charactersOfInitial[initial]![indexPath.row]
            cell.textLabel?.text = BibleData.characterName(id: id)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.search_active {
            //search active
            return nil
        }
        return self.initials[section]
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.search_active {
            //search active
            return nil
        }
        return self.initials
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.search_active {
            //search active
            let id = self.search_filtered[indexPath.row]
            self.delegate?.charactersViewController(self, didSelectCharacterOfID: id)
        } else {
            let initial = self.initials[indexPath.section]
            let id = self.charactersOfInitial[initial]![indexPath.row]
            self.delegate?.charactersViewController(self, didSelectCharacterOfID: id)
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

