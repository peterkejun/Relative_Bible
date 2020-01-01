//
//  BibleTextVC+Layout.swift
//  Bible
//
//  Created by Jun Ke on 8/22/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension BibleTextViewController {
    
    func layout() {
        self.searchBarItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(self.searchBarButtonPressed(_:)))
        self.infoBarItem = UIBarButtonItem.init(image: UIImage.init(named: "information"), style: .plain, target: self, action: #selector(self.informationBarButtonPressed(_:)))
        self.navigationItem.rightBarButtonItems = [
            self.searchBarItem,
            UIBarButtonItem.init(image: UIImage.init(named: "font size"), style: .plain, target: self, action: #selector(self.fontSizeBarButtonPressed(_:))),
            UIBarButtonItem.init(image: UIImage.init(named: "locate"), style: .plain, target: self, action: #selector(self.locateBarButtonPressed(_:))),
            self.infoBarItem,
            UIBarButtonItem.init(image: UIImage.init(named: "maximize"), style: .plain, target: self, action: #selector(self.fullScreenButtonPressed(_:)))
        ]
        
        self.bookToolBarItem = UIBarButtonItem.init(title: "Genesis", style: .plain, target: self, action: #selector(self.bookBarButtonItemPressed(_:)))
        self.versionToolBarItem = UIBarButtonItem.init(title: "KJV", style: .plain, target: self, action: #selector(self.versionBarButtonItemPressed(_:)))
        self.nextToolBarItem = UIBarButtonItem.init(image: UIImage.init(named: "right arrow"), style: .plain, target: self, action: #selector(self.nextBarButtonPressed(_:)))
        self.previousToolBarItem = UIBarButtonItem.init(image: UIImage.init(named: "left arrow"), style: .plain, target: self, action: #selector(self.previousBarButtonPressed(_:)))
        let flexibleSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.toolBar = UIToolbar.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        self.toolBar.setItems([
            self.bookToolBarItem,
            flexibleSpace,
            self.versionToolBarItem,
            flexibleSpace,
            self.previousToolBarItem,
            flexibleSpace,
            self.nextToolBarItem,
            flexibleSpace
            ], animated: false)
        self.toolBar.barTintColor = UIColor.barTintColor
        self.view.addSubview(self.toolBar)
        self.toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.toolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.toolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.toolBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.toolBar.heightAnchor.constraint(equalToConstant: self.toolBar.bounds.height).isActive = true
        
        self.searchBar = UISearchBar.init()
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.autocorrectionType = .yes
        self.searchBar.autocapitalizationType = .none
        self.searchBar.keyboardType = .default
        self.searchBar.keyboardAppearance = .dark
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
        self.searchBar.isHidden = true
        self.searchBar.backgroundColor = UIColor.init(hex: "555555")
        self.searchBar.tintColor = .white
        self.searchBar.barTintColor = UIColor.white
        self.searchBar.placeholder = "Search in \(self.book)"
        (self.searchBar.value(forKey: "searchField") as? UITextField)?.textColor = UIColor.white
        self.view.addSubview(self.searchBar)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.searchBarTopConstraint = self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:  -51)
        self.searchBarTopConstraint.isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: 51).isActive = true
        
        self.tableView = UITableView.init()
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = .none
        self.tableView.allowsMultipleSelection = false
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "BibleTextCell", bundle: nil), forCellReuseIdentifier: BibleTextCell.identifier)
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewLeadingConstraint = self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        self.tableViewLeadingConstraint.isActive = true
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.toolBar.topAnchor).isActive = true
        
        self.selectionView = SidebarSelectionView.init(frame: .init(x: 0, y: 0, width: self.chapterSelectionViewWidth, height: 300), book: self.book)
        self.selectionView.delegate = self
        self.selectionView.isUserInteractionEnabled = false
        self.selectionView.isHidden = true
        self.view.addSubview(self.selectionView)
        self.selectionView.translatesAutoresizingMaskIntoConstraints = false
        self.selectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.selectionView.bottomAnchor.constraint(equalTo: self.toolBar.topAnchor).isActive = true
        self.selectionView.trailingAnchor.constraint(equalTo: self.tableView.leadingAnchor).isActive = true
        self.selectionViewWidthConstraint = self.selectionView.widthAnchor.constraint(equalToConstant: self.chapterSelectionViewWidth)
        self.selectionViewWidthConstraint.isActive = true
        self.selectionView.layer.shadowColor = UIColor.black.cgColor
        self.selectionView.layer.shadowRadius = 5
        self.selectionView.layer.shadowOpacity = 0.3
        self.selectionView.layer.shadowOffset = .init(width: 2, height: 0)
        
        self.view.bringSubviewToFront(self.toolBar)
        
        BibleTextCell.textColor = TextOptionsViewController.themes[self.theme.rawValue][1]
        self.navigationController?.navigationBar.barTintColor = TextOptionsViewController.themes[self.theme.rawValue][0]
        self.navigationController?.navigationBar.tintColor = TextOptionsViewController.themes[self.theme.rawValue][2]
        self.tableView.backgroundColor = TextOptionsViewController.themes[self.theme.rawValue][0]
        self.toolBar.barTintColor = TextOptionsViewController.themes[self.theme.rawValue][0]
        self.toolBar.tintColor = TextOptionsViewController.themes[self.theme.rawValue][2]
        self.tabBarController?.tabBar.barTintColor = TextOptionsViewController.themes[self.theme.rawValue][0]
        self.tabBarController?.tabBar.tintColor = TextOptionsViewController.themes[self.theme.rawValue][2]
        
        self.minimizeButton = UIButton.init()
        self.minimizeButton.setImage(UIImage.init(named: "minimize"), for: .normal)
        self.minimizeButton.backgroundColor = UIColor.init(hex: "DCDCDC")
        self.minimizeButton.layer.borderWidth = 1
        self.minimizeButton.layer.borderColor = UIColor.init(hex: "979797").cgColor
        self.minimizeButton.layer.cornerRadius = 7
        self.minimizeButton.isHidden = true
        self.minimizeButton.addTarget(self, action: #selector(self.minimizeButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(self.minimizeButton)
        self.minimizeButton.translatesAutoresizingMaskIntoConstraints = false
        self.minimizeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.minimizeButton.bottomAnchor.constraint(equalTo: self.toolBar.topAnchor, constant: -20).isActive = true
        self.minimizeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.minimizeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
}

