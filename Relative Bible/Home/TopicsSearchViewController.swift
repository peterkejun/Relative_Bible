//
//  TopicsSearchViewController.swift
//  Bible
//
//  Created by Jun Ke on 8/24/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class TopicsSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    var initials: [String] = []
    var topicsOfInitial: [String: [String]] = [:]
    
    var searchTask: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        self.searchBar = UISearchBar.init()
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.placeholder = "Search all topics"
        self.navigationItem.titleView = self.searchBar
        
        self.tableView = UITableView.init()
        if #available(iOS 13.0, *) {
            self.tableView.sectionIndexColor = UIColor.label
            self.tableView.backgroundColor = UIColor.systemGray6
        } else {
            self.tableView.sectionIndexColor = UIColor.black.withAlphaComponent(0.7)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.initials = BibleData.topicInitials
        for initial in self.initials {
            let topics = BibleData.topics(ofInitial: initial)
            self.topicsOfInitial[initial] = topics
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.initials.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let initial = self.initials[section]
        return self.topicsOfInitial[initial]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let initial = self.initials[indexPath.section]
        cell.textLabel?.text = self.topicsOfInitial[initial]?[indexPath.row]
        if #available(iOS 13, *) {
            cell.backgroundColor = UIColor.systemGray6
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let initial = self.initials[indexPath.section]
        if let topic = self.topicsOfInitial[initial]?[indexPath.row] {
            let topicVC = TopicViewController.init()
            topicVC.topic = topic
            self.navigationController?.pushViewController(topicVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.initials[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.initials
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.initials = BibleData.topicInitials
        self.topicsOfInitial.removeAll()
        for initial in self.initials {
            let topics = BibleData.topics(ofInitial: initial)
            self.topicsOfInitial[initial] = topics
        }
        self.tableView.reloadData()
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
            self.initials = BibleData.topicInitials
            self.topicsOfInitial.removeAll()
            for initial in self.initials {
                let topics = BibleData.topics(ofInitial: initial)
                self.topicsOfInitial[initial] = topics
            }
            self.tableView.reloadData()
            return
        }
        self.initials = BibleData.initialsOfTopicsMatching(text: text)
        self.topicsOfInitial.removeAll()
        for initial in self.initials {
            self.topicsOfInitial[initial] = BibleData.topics(ofInitial: initial, andMatching: text)
        }
        self.tableView.reloadData()
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
