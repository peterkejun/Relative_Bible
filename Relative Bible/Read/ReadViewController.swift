//
//  ReadViewController.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController {
    
    //controls
    var orderControl: UISegmentedControl!
    var testamentSelector: TestamentSelector!
    
    //table views
    var otDivisionTableView: OTDivisionTableView!
    var otDivisionTableViewLeadingConstraint: NSLayoutConstraint!
    var otPlainTableView: OTPlainTableView!
    var ntDivisionTableView: NTDivisionTableView!
    var ntPlainTableView: NTPlainTableView!
    
    static let userDefaults = UserDefaults.standard
    
    //version
    static var version: BibleVersion = .KJV {
        didSet {
            userDefaults.set(ReadViewController.version.rawValue, forKey: "reading version")
        }
    }
    var versionBarButtonItem: UIBarButtonItem!
    
    //left off
    static var leftOff: VerseTag? = nil {
        didSet {
            userDefaults.set(ReadViewController.leftOff?.storageString, forKey: "left off")
        }
    }
    var leftOffBarButtonItem: UIBarButtonItem!
    
    //liked
    var likedBarButtonItem: UIBarButtonItem!
    
    //search
    var searchBarButtonItem: UIBarButtonItem!
    var searchBar: UISearchBar!
    var searchBarBottomConstraint: NSLayoutConstraint!
    var searchTask: DispatchWorkItem?
    var searchTableView: UITableView?
    var searchFiltered: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        //version
        if let savedVersionRaw = ReadViewController.userDefaults.string(forKey: "reading version"), let savedVersion = BibleVersion.init(rawValue: savedVersionRaw) {
            ReadViewController.version = savedVersion
        } else {
            ReadViewController.version = .KJV
        }
        
        //left off
        if let storageString = ReadViewController.userDefaults.string(forKey: "left off") {
            ReadViewController.leftOff = VerseTag.init(storageString: storageString)
        } else {
            ReadViewController.leftOff = nil
        }
        
        self.layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = nil
        self.updateForVersionChange()
        if ReadViewController.leftOff != nil {
            self.leftOffBarButtonItem.isEnabled = true
        } else {
            self.leftOffBarButtonItem.isEnabled = false
        }
    }
    
    func updateForVersionChange() {
        self.ntDivisionTableView.reloadData()
        self.ntPlainTableView.reloadData()
        self.otDivisionTableView.reloadData()
        self.otPlainTableView.reloadData()
        self.versionBarButtonItem.image = ReadViewController.version.image
    }
    
}
