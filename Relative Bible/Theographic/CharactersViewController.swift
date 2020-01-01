//
//  CharactersViewController.swift
//  Bible
//
//  Created by Jun Ke on 9/17/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol CharactersViewControllerDelegate: class {
    func charactersViewController(_ view_controller: UIViewController, didSelectCharacterOfID id: Int)
}

class CharactersViewController: UIViewController {
    
    weak var delegate: CharactersViewControllerDelegate?
    
    var tableView: UITableView!
    
    var search_bar: UISearchBar!
    
    var charactersOfInitial: [String: [Int]] = [:]
    var initials: [String] = []
    var search_filtered: [Int] = []
    
    var search_active: Bool = false
    var search_task: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Choose a Biblical Character"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelBarButtonPressed(_:)))
        
        self.resetData()
        
        self.search_bar = UISearchBar.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        self.search_bar.searchBarStyle = .default
        self.search_bar.delegate = self
        self.search_bar.autocorrectionType = .no
        self.search_bar.keyboardType = .asciiCapable
        self.search_bar.showsCancelButton = true
        self.search_bar.placeholder = "Search for a character"
        (self.search_bar.value(forKey: "searchField") as? UITextField)?.textColor = UIColor.black
        self.view.addSubview(self.search_bar)
        self.search_bar.translatesAutoresizingMaskIntoConstraints = false
        self.search_bar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.search_bar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.search_bar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.search_bar.heightAnchor.constraint(equalToConstant: self.search_bar.bounds.height).isActive = true
        
        self.tableView = UITableView.init(frame: self.view.bounds)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.tintColor = UIColor.black.withAlphaComponent(0.7)
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.search_bar.bottomAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
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

extension CharactersViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.search_task?.cancel()
        self.search_bar.resignFirstResponder()
        self.search_active = false
        //update table view
        self.resetData()
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search_task?.cancel()
        let task = DispatchWorkItem.init { [weak self] in
            self?.executeSearch(text: searchText)
        }
        self.search_task = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: task)
    }
    
    func executeSearch(text: String) {
        self.search_active = true
        if text.isEmpty || text.rangeOfCharacter(from: CharacterSet.alphanumerics) == nil {
            self.resetData()
            self.tableView.reloadData()
            return
        }
        self.search_filtered = BibleData.characterIDs(withPrefix: text)
        self.tableView.reloadData()
    }
    
    func resetData() {
        self.initials = BibleData.characterInitials
        for initial in self.initials {
            let character_ids = BibleData.characterIDs(ofInitial: initial)
            charactersOfInitial[initial] = character_ids
        }
    }
    
}
