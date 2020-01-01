//
//  ReadVC+Layout.swift
//  Bible
//
//  Created by Jun Ke on 8/25/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension ReadViewController {
    
    func layout() {
        //version
        self.versionBarButtonItem = UIBarButtonItem.init(image: ReadViewController.version.image, style: .plain, target: self, action: #selector(self.versionBarButtonPressed(_:)))
        self.navigationItem.rightBarButtonItems = [self.versionBarButtonItem]
        
        //left off
        self.leftOffBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "left off"), style: .plain, target: self, action: #selector(self.leftOffBarButtonPressed(_:)))
        self.navigationItem.leftBarButtonItems = [self.leftOffBarButtonItem]
        
        //liked
        self.likedBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "heart"), style: .plain, target: self, action: #selector(self.likedBarButtonPressed(_:)))
        self.navigationItem.leftBarButtonItems?.append(self.likedBarButtonItem)
        
        //locate
        let locateBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "locate"), style: .plain, target: self, action: #selector(self.locateBarButtonPressed(_:)))
        self.navigationItem.rightBarButtonItems?.append(locateBarButtonItem)
        
        //highlight
        let highlightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "edit"), style: .plain, target: self, action: #selector(self.highlightBarButtonPressed(_:)))
        self.navigationItem.leftBarButtonItems?.append(highlightBarButtonItem)
        
        //search
        self.searchBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(self.searchBarButtonPressed(_:)))
        self.navigationItem.leftBarButtonItems?.append(self.searchBarButtonItem)
        self.searchBar = UISearchBar.init()
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.placeholder = "Search for a book"
        self.view.addSubview(self.searchBar)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.searchBarBottomConstraint = self.searchBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
        self.searchBarBottomConstraint.isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: 51).isActive = true
        
        //controls
        orderControl = UISegmentedControl.init(items: ["by Division", "Original", "Alphabetical"])
        self.orderControl.selectedSegmentIndex = 0
        orderControl.addTarget(self, action: #selector(self.orderControlValueChanged), for: .valueChanged)
        self.view.addSubview(orderControl)
        orderControl.translatesAutoresizingMaskIntoConstraints = false
        orderControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        orderControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        orderControl.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 11).isActive = true
        orderControl.heightAnchor.constraint(equalToConstant: orderControl.bounds.height).isActive = true
        
        testamentSelector = TestamentSelector.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width - 32, height: TestamentSelector.standardHeight))
        testamentSelector.addTarget(self, action: #selector(self.testamentSelectorValueChanged))
        self.view.addSubview(testamentSelector)
        testamentSelector.translatesAutoresizingMaskIntoConstraints = false
        testamentSelector.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        testamentSelector.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        testamentSelector.topAnchor.constraint(equalTo: orderControl.bottomAnchor, constant: 16).isActive = true
        testamentSelector.heightAnchor.constraint(equalToConstant: testamentSelector.bounds.height).isActive = true
        
        //table views
        otDivisionTableView = OTDivisionTableView.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: 100), style: .grouped)
        otDivisionTableView.delegate = self
        self.view.addSubview(otDivisionTableView)
        otDivisionTableView.translatesAutoresizingMaskIntoConstraints = false
        otDivisionTableViewLeadingConstraint = otDivisionTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        otDivisionTableViewLeadingConstraint.isActive = true
        otDivisionTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        otDivisionTableView.topAnchor.constraint(equalTo: testamentSelector.bottomAnchor, constant: 18).isActive = true
        otDivisionTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        otPlainTableView = OTPlainTableView.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: 100), style: .plain)
        otPlainTableView.isHidden = true
        otPlainTableView.delegate = self
        self.view.addSubview(otPlainTableView)
        otPlainTableView.translatesAutoresizingMaskIntoConstraints = false
        otPlainTableView.leadingAnchor.constraint(equalTo: otDivisionTableView.leadingAnchor).isActive = true
        otPlainTableView.trailingAnchor.constraint(equalTo: otDivisionTableView.trailingAnchor).isActive = true
        otPlainTableView.topAnchor.constraint(equalTo: otDivisionTableView.topAnchor).isActive = true
        otPlainTableView.bottomAnchor.constraint(equalTo: otDivisionTableView.bottomAnchor).isActive = true
        
        ntDivisionTableView = NTDivisionTableView.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: 100), style: .grouped)
        ntDivisionTableView.isHidden = false
        ntDivisionTableView.delegate = self
        self.view.addSubview(ntDivisionTableView)
        ntDivisionTableView.translatesAutoresizingMaskIntoConstraints = false
        ntDivisionTableView.leadingAnchor.constraint(equalTo: otDivisionTableView.trailingAnchor).isActive = true
        ntDivisionTableView.widthAnchor.constraint(equalTo: otDivisionTableView.widthAnchor, multiplier: 1).isActive = true
        ntDivisionTableView.topAnchor.constraint(equalTo: otDivisionTableView.topAnchor).isActive = true
        ntDivisionTableView.bottomAnchor.constraint(equalTo: otDivisionTableView.bottomAnchor).isActive = true
        
        ntPlainTableView = NTPlainTableView.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: 100), style: .plain)
        ntPlainTableView.isHidden = true
        ntPlainTableView.delegate = self
        self.view.addSubview(ntPlainTableView)
        ntPlainTableView.translatesAutoresizingMaskIntoConstraints = false
        ntPlainTableView.leadingAnchor.constraint(equalTo: ntDivisionTableView.leadingAnchor).isActive = true
        ntPlainTableView.trailingAnchor.constraint(equalTo: ntDivisionTableView.trailingAnchor).isActive = true
        ntPlainTableView.topAnchor.constraint(equalTo: ntDivisionTableView.topAnchor).isActive = true
        ntPlainTableView.bottomAnchor.constraint(equalTo: ntDivisionTableView.bottomAnchor).isActive = true
        
        self.view.layoutIfNeeded()
    }
    
}

