//
//  HomeVC+VOTD.swift
//  Bible
//
//  Created by Jun Ke on 8/23/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit
import Photos

extension HomeViewController {
    
    func layoutVerseOfTheDay() {
        var color = UIColor.black.withAlphaComponent(0.7)
        if #available(iOS 13.0, *) {
            color = UIColor.label.withAlphaComponent(0.7)
        }
        
        self.votdView = UIView.init()
        self.votdView.backgroundColor = UIColor.clear
        self.votdView.clipsToBounds = true
        self.scrollView.addSubview(self.votdView)
        self.votdView.translatesAutoresizingMaskIntoConstraints = false
        self.votdView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.votdView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.votdView.topAnchor.constraint(equalTo: self.topicsScrollableView.bottomAnchor, constant: 20).isActive = true
        self.votdViewHeightConstraint = self.votdView.heightAnchor.constraint(equalToConstant: self.placeholderHeight)
        self.votdViewHeightConstraint.isActive = true
        
        let vertical = self.verticalLine
        vertical.backgroundColor = color
        self.votdView.addSubview(vertical)
        vertical.translatesAutoresizingMaskIntoConstraints = false
        vertical.leadingAnchor.constraint(equalTo: self.votdView.leadingAnchor, constant: 15).isActive = true
        vertical.topAnchor.constraint(equalTo: self.votdView.topAnchor).isActive = true
        vertical.bottomAnchor.constraint(equalTo: self.votdView.bottomAnchor).isActive = true
        vertical.widthAnchor.constraint(equalTo: self.votdView.widthAnchor, multiplier: 14 / 375).isActive = true
        
        let label = UILabel.init()
        label.text = "Verse of the Day"
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textColor = color
        self.votdView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: vertical.trailingAnchor, constant: 11).isActive = true
        label.topAnchor.constraint(equalTo: self.votdView.topAnchor).isActive = true
        
        self.verseTagLabel = UILabel.init()
        self.verseTagLabel.text = "verse tag"
        self.verseTagLabel.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        self.verseTagLabel.textColor = color
        self.votdView.addSubview(self.verseTagLabel)
        self.verseTagLabel.translatesAutoresizingMaskIntoConstraints = false
        self.verseTagLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        self.verseTagLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7).isActive = true
        
        self.verseLabel = UILabel.init()
        self.verseLabel.text = "verse"
        self.verseLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        self.verseLabel.textColor = color
        self.verseLabel.numberOfLines = 0
        self.votdView.addSubview(self.verseLabel)
        self.verseLabel.translatesAutoresizingMaskIntoConstraints = false
        self.verseLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        self.verseLabel.trailingAnchor.constraint(equalTo: self.votdView.trailingAnchor, constant: -16).isActive = true
        self.verseLabel.topAnchor.constraint(equalTo: self.verseTagLabel.bottomAnchor, constant: 19).isActive = true
        
        let seperator = self.seperator
        self.votdView.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        seperator.trailingAnchor.constraint(equalTo: self.verseLabel.trailingAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: self.verseLabel.bottomAnchor, constant: 8).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.thoughtsLabel = UILabel.init()
        var thoughts_attributes = self.thoughtsAttributes
        thoughts_attributes[NSAttributedString.Key.foregroundColor] = color
        self.thoughtsLabel.attributedText = NSAttributedString.init(string: "thoughts", attributes: thoughts_attributes)
        self.thoughtsLabel.numberOfLines = 0
        self.votdView.addSubview(self.thoughtsLabel)
        self.thoughtsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.thoughtsLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        self.thoughtsLabel.trailingAnchor.constraint(equalTo: self.verseLabel.trailingAnchor).isActive = true
        self.thoughtsLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 5).isActive = true
        
        let shareButton = UIButton.init()
        shareButton.setImage(UIImage.init(named: "share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.addTarget(self, action: #selector(self.shareVOTD(_:)), for: .touchUpInside)
        self.votdView.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor, multiplier: 1.0).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: self.votdView.trailingAnchor, constant: -29).isActive = true
        shareButton.topAnchor.constraint(equalTo: self.votdView.topAnchor, constant: 7).isActive = true
        
        self.prayerButton = UIButton.init()
        self.prayerButton.setTitle("Amen? Click for a prayer.", for: .normal)
        self.prayerButton.setTitleColor(color, for: .normal)
        self.prayerButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        self.prayerButton.addTarget(self, action: #selector(self.prayerButtonTouchUpInside(_:)), for: .touchUpInside)
        self.votdView.addSubview(self.prayerButton)
        self.prayerButton.translatesAutoresizingMaskIntoConstraints = false
        self.prayerButton.centerXAnchor.constraint(equalTo: self.thoughtsLabel.centerXAnchor).isActive = true
        self.prayerButton.topAnchor.constraint(equalTo: self.thoughtsLabel.bottomAnchor, constant: 10).isActive = true
        
        self.prayerLabel = UILabel.init()
        var prayer_attributes = self.prayerAttributes
        prayer_attributes[NSAttributedString.Key.foregroundColor] = color
        self.prayerLabel.attributedText = NSAttributedString.init(string: "prayer", attributes: prayer_attributes)
        self.prayerLabel.numberOfLines = 0
        self.votdView.addSubview(self.prayerLabel)
        self.prayerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.prayerLabel.leadingAnchor.constraint(equalTo: self.thoughtsLabel.leadingAnchor).isActive = true
        self.prayerLabel.trailingAnchor.constraint(equalTo: self.thoughtsLabel.trailingAnchor).isActive = true
        self.prayerLabel.topAnchor.constraint(equalTo: self.prayerButton.bottomAnchor, constant: 10).isActive = true
        
        self.votd_spinner = UIActivityIndicatorView.init(style: .gray)
        self.votd_spinner?.translatesAutoresizingMaskIntoConstraints = false
        self.votd_spinner?.startAnimating()
        self.votdView.addSubview(self.votd_spinner!)

        self.votd_spinner?.centerXAnchor.constraint(equalTo: self.votdView.centerXAnchor).isActive = true
        self.votd_spinner?.centerYAnchor.constraint(equalTo: self.votdView.centerYAnchor).isActive = true
        
        NetworkManager.register(target: self, selector: #selector(self.updateVerseOfTheDay(_:)), dataType: .verseOfTheDay)
    }
    
    @objc func prayerButtonTouchUpInside(_ sender: UIButton) {
        if self.collapsePrayer {
            self.collapsePrayer = false
            UIView.animate(withDuration: 0.3) {
                self.votdViewHeightConstraint.constant = self.prayerButton.frame.maxY
                self.scrollView.layoutIfNeeded()
            }
        } else {
            self.collapsePrayer = true
            UIView.animate(withDuration: 0.3) {
                self.votdViewHeightConstraint.constant = self.prayerLabel.frame.maxY
                self.scrollView.layoutIfNeeded()
            }
        }
    }
    
    @objc func updateVerseOfTheDay(_ votd: [String: Any]) {
        print("attemp to update verse of the day")
        guard
            let verseTag = votd["tag"] as? VerseTag,
            let thoughts = votd["thoughts"] as? String,
            let prayer = votd["prayer"] as? String
            else {
                return
        }
        DispatchQueue.main.async {
            self.votd_spinner?.stopAnimating()
            self.votd_spinner?.removeFromSuperview()
            self.verseTagLabel.text = verseTag.description
            self.verseLabel.text = BibleData.bibleText(book: verseTag.book, chapter: verseTag.chapter, verseNumber: verseTag.verseNum)
            self.thoughtsLabel.attributedText = NSAttributedString.init(string: thoughts, attributes: self.thoughtsAttributes)
            self.prayerLabel.attributedText = NSAttributedString.init(string: prayer, attributes: self.prayerAttributes)
            self.votdView.layoutIfNeeded()
            if self.collapsePrayer {
                self.votdViewHeightConstraint.constant = self.prayerLabel.frame.maxY
            } else {
                self.votdViewHeightConstraint.constant = self.prayerButton.frame.maxY
            }
            self.scrollView.layoutIfNeeded()
            self.scrollView.contentSize = CGSize.init(width: self.scrollView.bounds.width, height: self.tdView.frame.maxY + 20)
        }
        
    }
    
    @objc func shareVOTD(_ sender: UIButton) {
        if let snapshot = self.votdView.snapshotView(afterScreenUpdates: true) {
            let image = snapshot.renderedImage
            let alertController = UIAlertController.init(title: "Share Verse of the Day", message: "An image of the \"Verse of the Day\" section is created for you.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "Save Image", style: .default, handler: { (_) in
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
            }))
            alertController.addAction(UIAlertAction.init(title: "Continue Sharing", style: .default, handler: { (_) in
                let activityController = UIActivityViewController.init(activityItems: [image], applicationActivities: nil)
                alertController.dismiss(animated: true, completion: nil)
                self.present(activityController, animated: true, completion: nil)
            }))
            alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (_) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alertController = UIAlertController.init(title: "Image Saved!", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate var thoughtsAttributes: [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 9
        paragraphStyle.firstLineHeadIndent = 34
        var color = UIColor.black.withAlphaComponent(0.7)
        if #available(iOS 13.0, *) {
            color = UIColor.label.withAlphaComponent(0.7)
        }
        return [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .light),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
    }
    
    fileprivate var prayerAttributes: [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 9
        paragraphStyle.firstLineHeadIndent = 34
        var color = UIColor.black.withAlphaComponent(0.7)
        if #available(iOS 13.0, *) {
            color = UIColor.label.withAlphaComponent(0.7)
        }
        return [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .light).with(.traitItalic),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
    }
    
}

