//
//  ReadVC+Controls.swift
//  Bible
//
//  Created by Jun Ke on 8/21/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension ReadViewController {
    
    @objc func highlightBarButtonPressed(_ sender: UIBarButtonItem) {
        let highlightVC = HighlightVersesController.init()
        highlightVC.delegate = self
        self.navigationController?.pushViewController(highlightVC, animated: true)
    }
    
    @objc func locateBarButtonPressed(_ sender: UIBarButtonItem) {
        let locateOptionsVC = LocateOptionsViewController.init()
        locateOptionsVC.modalPresentationStyle = .popover
        locateOptionsVC.preferredContentSize = LocateOptionsViewController.preferredSize
        locateOptionsVC.delegate = self
        let popController = locateOptionsVC.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.delegate = self
        popController?.barButtonItem = sender
        popController?.backgroundColor = locateOptionsVC.view.backgroundColor
        self.present(locateOptionsVC, animated: true, completion: nil)
    }
    
    @objc func versionBarButtonPressed(_ sender: UIBarButtonItem) {
        let versionOptionsVC = VersionOptionsViewController.init()
        versionOptionsVC.modalPresentationStyle = .popover
        versionOptionsVC.preferredContentSize = VersionOptionsViewController.preferredSize
        versionOptionsVC.delegate = self
        let popController = versionOptionsVC.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.delegate = self
        popController?.barButtonItem = sender
        popController?.backgroundColor = versionOptionsVC.view.backgroundColor
        self.present(versionOptionsVC, animated: true) {
            
        }
    }
    
    @objc func leftOffBarButtonPressed(_ sender: UIBarButtonItem) {
        if let leftOff = ReadViewController.leftOff {
            let bibleTextVC = BibleTextViewController.init()
            bibleTextVC.book = leftOff.book
            bibleTextVC.chapter = leftOff.chapter
            self.navigationController?.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(bibleTextVC, animated: true)
            bibleTextVC.indexPathToShowAtVisible = IndexPath.init(row: leftOff.verseNum - 1, section: 0)
        }
    }
    
    @objc func likedBarButtonPressed(_ sender: UIBarButtonItem) {
        let likedVC = LikedVersesController.init()
        likedVC.delegate = self
        self.navigationController?.pushViewController(likedVC, animated: true)
    }
    
    @objc func searchBarButtonPressed(_ sender: UIBarButtonItem) {
        if self.searchBarBottomConstraint.constant == 0 {
            //show search bar and search table view
            self.searchTableView?.removeFromSuperview()
            self.searchTableView = UITableView.init()
            self.searchTableView?.alpha = 0
            self.searchTableView?.keyboardDismissMode = .onDrag
            self.searchTableView?.dataSource = self
            self.searchTableView?.delegate = self
            self.searchTableView?.register(UINib.init(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: BookTableViewCell.identifier)
            self.view.addSubview(self.searchTableView!)
            self.searchTableView?.translatesAutoresizingMaskIntoConstraints = false
            self.searchTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            self.searchTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            self.searchTableView?.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
            self.searchTableView?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            self.searchFiltered = BibleData.wholeBibleNames
            UIView.animate(withDuration: 0.3) {
                self.searchBarBottomConstraint.constant = 51
                self.searchTableView?.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            //dismiss search bar and search table view
            self.searchBar.resignFirstResponder()
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBarBottomConstraint.constant = 0
                self.searchTableView?.alpha = 0
                self.view.layoutIfNeeded()
            }) { (_) in
                self.searchTableView?.removeFromSuperview()
                self.searchTableView = nil
                self.searchFiltered = []
            }
        }
    }
    
    @objc func orderControlValueChanged() {
        if orderControl.selectedSegmentIndex == 0 {
            otDivisionTableView.isHidden = false
            otPlainTableView.isHidden = true
            ntDivisionTableView.isHidden = false
            ntPlainTableView.isHidden = true
        } else if orderControl.selectedSegmentIndex == 1 {
            otDivisionTableView.isHidden = true
            otPlainTableView.isHidden = false
            otPlainTableView.mode = .original
            ntDivisionTableView.isHidden = true
            ntPlainTableView.isHidden = false
            ntPlainTableView.mode = .original
        } else if orderControl.selectedSegmentIndex == 2 {
            otDivisionTableView.isHidden = true
            otPlainTableView.isHidden = false
            otPlainTableView.mode = .alphabetical
            ntDivisionTableView.isHidden = true
            ntPlainTableView.isHidden = false
            ntPlainTableView.mode = .alphabetical
        }
    }
    
    @objc func testamentSelectorValueChanged() {
        let duration: Double = 0.3
        if testamentSelector.selected == 0 {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: duration, animations: {
                self.otDivisionTableViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { (_) in
                self.view.isUserInteractionEnabled = true
            }
        } else if testamentSelector.selected == 1 {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: duration, animations: {
                self.otDivisionTableViewLeadingConstraint.constant = -self.view.bounds.width
                self.view.layoutIfNeeded()
            }) { (_) in
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
}

extension ReadViewController: HighlightVersesControllerDelegate {
    func highlightVersesController(_ viewController: HighlightVersesController, didSelectVerse verseTag: VerseTag) {
        self.navigationController?.popViewController(animated: true)
        let bibleTextVC = BibleTextViewController.init()
        bibleTextVC.book = verseTag.book
        bibleTextVC.chapter = verseTag.chapter
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(bibleTextVC, animated: true)
        bibleTextVC.indexPathToShowAtVisible = IndexPath.init(row: verseTag.verseNum - 1, section: 0)
    }
}

extension ReadViewController: LikedVersesControllerDelegate {
    func likedVersesController(_ viewController: LikedVersesController, didSelectVerse verseTag: VerseTag) {
        self.navigationController?.popViewController(animated: true)
        let bibleTextVC = BibleTextViewController.init()
        bibleTextVC.book = verseTag.book
        bibleTextVC.chapter = verseTag.chapter
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(bibleTextVC, animated: true)
        bibleTextVC.indexPathToShowAtVisible = IndexPath.init(row: verseTag.verseNum - 1, section: 0)
    }
}

extension ReadViewController: VersionOptionsViewControllerDelegate {
    func versionOptionsViewController(_ viewController: VersionOptionsViewController, didSelectVersion version: BibleVersion) {
        ReadViewController.version = version
        self.updateForVersionChange()
        viewController.dismiss(animated: true) {
            
        }
    }
}

extension ReadViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ReadViewController: LocateOptionsViewControllerDelegate {
    
    var textForTitleLabel: String {
        return "Go to book"
    }
    
    func text(forSliderValue value: Float) -> String {
        return BibleData.book(id: Int(value) - 1, version: ReadViewController.version) ?? "Not Found"
    }
    
    var numberOfUnits: Int {
        return BibleData.books(version: ReadViewController.version).count
    }
    
    func locateOptionsViewController(_ viewController: LocateOptionsViewController, didEndSliderActionWithValue value: Float) {
        guard let bookNative = BibleData.book(id: Int(value) - 1, version: ReadViewController.version), let bookEnglish = BibleData.convertToEnglish(bookNative: bookNative, ofVersion: ReadViewController.version) else { return }
        let bibleTextVC = BibleTextViewController.init()
        bibleTextVC.book = bookEnglish
        viewController.dismiss(animated: true) {
            self.navigationController?.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(bibleTextVC, animated: true)
        }
    }
    
}

