//
//  BibleTextVC+Popup.swift
//  Bible
//
//  Created by Jun Ke on 8/14/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension BibleTextViewController {
    
    func showPopup(verse: Verse) {
        self.popupDismissButton?.removeFromSuperview()
        self.popupDismissButton = UIButton.init()
        self.popupDismissButton?.backgroundColor = UIColor.black
        self.popupDismissButton?.alpha = 0
        self.popupDismissButton?.addTarget(self, action: #selector(self.dismissPopup), for: .touchUpInside)
        self.popupDismissButton?.isUserInteractionEnabled = false
        self.view.addSubview(self.popupDismissButton!)
        self.popupDismissButton?.translatesAutoresizingMaskIntoConstraints = false
        self.popupDismissButton?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.popupDismissButton?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.popupDismissButton?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.popupDismissButton?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.popupView?.removeFromSuperview()
        self.popupView = VersePopupView.init(frame: .init(x: 0, y: 100, width: self.view.bounds.width, height: 400), verse: verse)
        self.popupView?.delegate = self
        self.popupView?.isUserInteractionEnabled = true
        self.view.addSubview(self.popupView!)
        self.popupView?.translatesAutoresizingMaskIntoConstraints = false
        self.popupView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.popupView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.popupViewBottomConstraint = self.popupView?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: self.popupView!.bounds.height + 30)
        self.popupViewBottomConstraint?.isActive = true
        self.popupView?.heightAnchor.constraint(equalToConstant: self.popupView!.bounds.height).isActive = true

        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.popupDismissButton?.alpha = 0.3
            self.popupViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.popupView?.isUserInteractionEnabled = true
            self.popupDismissButton?.isUserInteractionEnabled = true
        }
    }
    
    @objc func dismissPopup() {
        guard let button = self.popupDismissButton, let popupView = self.popupView, let bottomConstraint = self.popupViewBottomConstraint else {
            return
        }
        button.isUserInteractionEnabled = false
        popupView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            button.alpha = 0
            bottomConstraint.constant = popupView.bounds.height + 10
            self.view.layoutIfNeeded()
        }) { (_) in
            self.popupDismissButton?.removeFromSuperview()
            self.popupDismissButton = nil
            self.popupView?.removeFromSuperview()
            self.popupView = nil
        }
    }
    
}

extension BibleTextViewController: VersePopupViewDelegate {
    
    func dismissPopupView(_ popupView: VersePopupView) {
        self.dismissPopup()
    }
    
    var alertControllerPresentable: UIViewController {
        return (self as UIViewController)
    }
    
    func setHighlightColor(_ color: UIColor?) {
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow, let cell = self.tableView.cellForRow(at: selectedIndexPath) as? BibleTextCell else { return }
        self.setHighlight(cell: cell, color: color)
        UserData.setHighlightColor(book: self.book, chapter: self.chapter, verse: selectedIndexPath.row + 1, color: color, date: Date.init())
    }
    
    func setVerseLiked(_ flag: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let impactGenerator = UIImpactFeedbackGenerator.init(style: .light)
            impactGenerator.prepare()
            if flag {
                UserData.addLiked(book: self.book, chapter: self.chapter, verse: indexPath.row + 1)
            } else {
                UserData.removeLiked(book: self.book, chapter: self.chapter, verse: indexPath.row + 1)
            }
            impactGenerator.impactOccurred()
        }
    }
    
}

