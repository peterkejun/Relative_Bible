//
//  BibleTextVC+Controls.swift
//  Bible
//
//  Created by Jun Ke on 8/6/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension BibleTextViewController {
    
    @objc func informationBarButtonPressed(_ sender: UIBarButtonItem) {
//        let bookInfoVC = BookInfoViewController.init()
//        self.navigationController?.pushViewController(bookInfoVC, animated: true)
    }
    
    @objc func locateBarButtonPressed(_ sender: UIBarButtonItem) {
        if self.verses.count == 0 {
            return
        }
        let locateOptionsVC = LocateOptionsViewController.init()
        locateOptionsVC.modalPresentationStyle = .popover
        locateOptionsVC.preferredContentSize = LocateOptionsViewController.preferredSize
        locateOptionsVC.delegate = self
        let popController = locateOptionsVC.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.delegate = self
        popController?.barButtonItem = sender
        popController?.backgroundColor = locateOptionsVC.view.backgroundColor
        self.present(locateOptionsVC, animated: true) {
            if let currentIndexPath = self.tableView.indexPathsForVisibleRows?.first {
                locateOptionsVC.locateSlider.setValue(Float(currentIndexPath.row), animated: true)
            }
        }
    }
    
    @objc func searchBarButtonPressed(_ sender: UIBarButtonItem) {
        //turn dark
        if self.searchBarTopConstraint.constant == -51 {
            self.searchBar.becomeFirstResponder()
            self.searchBar.isHidden = false
            BibleTextCell.textColor = UIColor.white
            self.tableView.reloadData()
            UIView.animate(withDuration: self.searchBarAnimationDuration, animations: {
                self.searchBarTopConstraint.constant = 0
                self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: "555555")
                self.navigationController?.navigationBar.tintColor = UIColor.white
                self.toolBar.barTintColor = UIColor.init(hex: "555555")
                self.toolBar.tintColor = UIColor.white
                self.tableView.backgroundColor = UIColor.init(hex: "555555")
                self.view.layoutIfNeeded()
            }) { (_) in
                self.searchBar.isUserInteractionEnabled = true
            }
            sender.image = UIImage.init(named: "search focused")
        } else {
            //turn light
            self.searchBar.resignFirstResponder()
            BibleTextCell.textColor = TextOptionsViewController.themes[self.theme.rawValue][1]
            self.verses = self.fetchText(book: self.book, chapter: self.chapter, version: ReadViewController.version, size: self.fontSize)
            self.tableView.reloadData()
            UIView.animate(withDuration: self.searchBarAnimationDuration, animations: {
                self.searchBarTopConstraint.constant = -51
                self.navigationController?.navigationBar.barTintColor = TextOptionsViewController.themes[self.theme.rawValue][0]
                self.navigationController?.navigationBar.tintColor = TextOptionsViewController.themes[self.theme.rawValue][2]
                self.tableView.backgroundColor = TextOptionsViewController.themes[self.theme.rawValue][0]
                self.toolBar.barTintColor = TextOptionsViewController.themes[self.theme.rawValue][0]
                self.toolBar.tintColor = TextOptionsViewController.themes[self.theme.rawValue][2]
                self.view.layoutIfNeeded()
            }) { (_) in
                self.searchBar.isUserInteractionEnabled = false
                self.searchBar.isHidden = true
            }
            sender.image = UIImage.init(named: "search")
        }
    }
    
    @objc func fontSizeBarButtonPressed(_ sender: UIBarButtonItem) {
        let textOptionsVC = TextOptionsViewController.init()
        textOptionsVC.modalPresentationStyle = .popover
        textOptionsVC.preferredContentSize = TextOptionsViewController.preferredSize
        textOptionsVC.delegate = self
        let popController = textOptionsVC.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.delegate = self
        popController?.barButtonItem = sender
        popController?.backgroundColor = textOptionsVC.view.backgroundColor
        self.present(textOptionsVC, animated: true) {
            
        }
    }
    
    @objc func bookBarButtonItemPressed(_ sender: UIBarButtonItem) {
        if self.tableViewLeadingConstraint.constant == 0 {
            self.selectionView.setMode(.chapter)
            self.showSelectionView()
        } else {
            if self.selectionView.mode == .chapter {
                self.dismissSelectionView()
            } else {
                self.selectionView.setMode(.chapter)
                self.showSelectionView()
            }
        }
    }
    
    @objc func versionBarButtonItemPressed(_ sender: UIBarButtonItem) {
        if self.tableViewLeadingConstraint.constant == 0 {
            self.selectionView.setMode(.version)
            self.showSelectionView()
        } else {
            if self.selectionView.mode == .version {
                self.dismissSelectionView()
            } else {
                self.selectionView.setMode(.version)
                self.showSelectionView()
            }
        }
    }
    
    @objc func nextBarButtonPressed(_ sender: UIBarButtonItem) {
        let next = self.nextChapter(current: self.chapter)
        if next != -1 {
            self.chapter = next
            self.updateToolBar()
            self.verses = self.fetchText(book: self.book, chapter: self.chapter, version: ReadViewController.version, size: self.fontSize)
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            if self.nextChapter(current: self.chapter) == -1 {
                nextToolBarItem.isEnabled = false
                previousToolBarItem.isEnabled = true
            } else {
                nextToolBarItem.isEnabled = true
                previousToolBarItem.isEnabled = true
            }
        }
    }
    
    @objc func previousBarButtonPressed(_ sender: UIBarButtonItem) {
        let previous = self.previousChapter(current: self.chapter)
        if previous != -1 {
            self.chapter = previous
            self.updateToolBar()
            self.verses = self.fetchText(book: self.book, chapter: self.chapter, version: ReadViewController.version, size: self.fontSize)
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            if self.previousChapter(current: self.chapter) == -1 {
                previousToolBarItem.isEnabled = false
                nextToolBarItem.isEnabled = true
            } else {
                previousToolBarItem.isEnabled = true
                nextToolBarItem.isEnabled = true
            }
        }
    }
    
    @objc func fullScreenButtonPressed(_ sender: UIBarButtonItem) {
        self.minimizeButton.isHidden = false
        self.minimizeButton.alpha = 0.5
        self.navigationController?.isNavigationBarHidden = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func minimizeButtonPressed(_ sender: UIButton) {
        self.minimizeButton.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension BibleTextViewController: LocateOptionsViewControllerDelegate {
    
    func locateOptionsViewController(_ viewController: LocateOptionsViewController, didEndSliderActionWithValue value: Float) {
        self.tableView.scrollToRow(at: IndexPath.init(row: Int(value) - 1, section: 0), at: .none, animated: true)
    }
    
    func text(forSliderValue value: Float) -> String {
        return self.book + " \(self.chapter):\(Int(value))"
    }
    
    var textForTitleLabel: String {
        return "Jumping to"
    }
    
    var numberOfUnits: Int {
        return self.verses.count
    }
    
}

extension BibleTextViewController: TextOptionsViewControllerDelegate {
    
    func textOptionsViewController(_ viewController: TextOptionsViewController, didChangeFontSizeWithDirection direction: Int) {
        if self.fontSize + CGFloat(direction) <= self.maxFontSize && self.fontSize + CGFloat(direction) >= self.minFontSize {
            self.fontSize += CGFloat(direction)
        }
    }
    
    func textOptionsViewController(_ viewController: TextOptionsViewController, didChooseNewTheme theme: TextOptionsViewController.Theme) {
        let colors = TextOptionsViewController.themes[theme.rawValue]
        BibleTextCell.textColor = colors[1]
        self.tableView.backgroundColor = colors[0]
        self.tableView.reloadData()
        self.navigationController?.navigationBar.barTintColor = colors[0]
        self.navigationController?.navigationBar.tintColor = colors[2]
        self.toolBar.barTintColor = colors[0]
        self.toolBar.tintColor = colors[2]
        self.tabBarController?.tabBar.barTintColor = colors[0]
        self.tabBarController?.tabBar.tintColor = colors[2]
        self.theme = theme
    }
    
    var maxFontSize: CGFloat {
        return 30
    }
    
    var minFontSize: CGFloat {
        return 9
    }
    
}

extension BibleTextViewController: SidebarSelectionViewDelegate {
    
    func sidebarSelectionView(_ sidebarSelectionView: SidebarSelectionView, didSelectChapter chapter: Int) {
        self.dismissSelectionView()
        self.chapter = chapter
        self.verses = self.fetchText(book: self.book, chapter: self.chapter, version: ReadViewController.version, size: self.fontSize)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .none, animated: false)
        self.updateToolBar()
    }
    
    func sidebarSelectionView(_ sidebarSelectionView: SidebarSelectionView, didSelectVersion version: BibleVersion) {
        self.dismissSelectionView()
        ReadViewController.version = version
        self.verses = self.fetchText(book: self.book, chapter: self.chapter, version: version, size: self.fontSize)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .none, animated: false)
        self.updateToolBar()
        UserDefaults.standard.set(version.rawValue, forKey: "reading version")
    }
    
    func showSelectionView() {
        self.selectionView.isUserInteractionEnabled = false
        self.selectionView.isHidden = false
        UIView.animate(withDuration: self.searchBarAnimationDuration, animations: {
            self.tableViewLeadingConstraint.constant = self.selectionView.mode == .chapter ? self.chapterSelectionViewWidth : self.versionSelectionViewWidth
            self.selectionViewWidthConstraint.constant = self.selectionView.mode == .chapter ? self.chapterSelectionViewWidth : self.versionSelectionViewWidth
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.selectionView.isUserInteractionEnabled = true
        })
        self.selectionViewDismissButton?.removeFromSuperview()
        self.selectionViewDismissButton = UIButton.init()
        self.selectionViewDismissButton?.addTarget(self, action: #selector(self.dummyButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(self.selectionViewDismissButton!)
        self.selectionViewDismissButton?.translatesAutoresizingMaskIntoConstraints = false
        self.selectionViewDismissButton?.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor).isActive = true
        self.selectionViewDismissButton?.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor).isActive = true
        self.selectionViewDismissButton?.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        self.selectionViewDismissButton?.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true
        self.view.layoutIfNeeded()
    }
    
    @objc func dummyButtonPressed(_ sender: UIButton) {
        self.dismissSelectionView()
    }
    
    func dismissSelectionView() {
        self.selectionViewDismissButton?.removeFromSuperview()
        self.selectionView.isUserInteractionEnabled = false
        UIView.animate(withDuration: self.searchBarAnimationDuration, animations: {
            self.tableViewLeadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.selectionView.isHidden = true
        }
    }
    
    var chapterSelectionViewWidth: CGFloat {
        return 200
    }
    
    var versionSelectionViewWidth: CGFloat {
        return 300
    }
    
}

