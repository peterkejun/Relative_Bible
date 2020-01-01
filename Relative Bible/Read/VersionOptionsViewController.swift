//
//  VersionOptionsViewController.swift
//  Bible
//
//  Created by Jun Ke on 8/21/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol VersionOptionsViewControllerDelegate: class {
    func versionOptionsViewController(_ viewController: VersionOptionsViewController, didSelectVersion version: BibleVersion)
}

class VersionOptionsViewController: UIViewController {
    
    weak var delegate: VersionOptionsViewControllerDelegate?
    
    var sidebarSelectionView: SidebarSelectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(hex: "555555")
        
        self.sidebarSelectionView = SidebarSelectionView.init(frame: .init(origin: .zero, size: VersionOptionsViewController.preferredSize))
        self.sidebarSelectionView.accessoryType = .none
        self.sidebarSelectionView.delegate = self
        self.view.addSubview(self.sidebarSelectionView)
        self.sidebarSelectionView.translatesAutoresizingMaskIntoConstraints = false
        self.sidebarSelectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.sidebarSelectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.sidebarSelectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.sidebarSelectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.sidebarSelectionView.setMode(.version)
    }
    
    static var preferredSize: CGSize {
        return .init(width: 300, height: 500)
    }
    
}

extension VersionOptionsViewController: SidebarSelectionViewDelegate {
    
    func sidebarSelectionView(_ sidebarSelectionView: SidebarSelectionView, didSelectChapter chapter: Int) {
        
    }
    
    func sidebarSelectionView(_ sidebarSelectionView: SidebarSelectionView, didSelectVersion version: BibleVersion) {
        self.delegate?.versionOptionsViewController(self, didSelectVersion: version)
    }
    
}

