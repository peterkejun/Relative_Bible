//
//  HomeVC+TD.swift
//  Bible
//
//  Created by Jun Ke on 8/24/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension HomeViewController {
    
    func layoutTodaysDevotional() {
        var color = UIColor.black.withAlphaComponent(0.7)
        if #available(iOS 13.0, *) {
            color = UIColor.label.withAlphaComponent(0.7)
        }
        
        self.tdView = UIView.init()
        self.scrollView.addSubview(self.tdView)
        self.tdView.translatesAutoresizingMaskIntoConstraints = false
        self.tdView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tdView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tdView.topAnchor.constraint(equalTo: self.votdView.bottomAnchor, constant: 20).isActive = true
        self.tdViewHeightConstraint = self.tdView.heightAnchor.constraint(equalToConstant: self.placeholderHeight)
        self.tdViewHeightConstraint.isActive = true
        
        let vertical = self.verticalLine
        vertical.backgroundColor = color
        self.tdView.addSubview(vertical)
        vertical.translatesAutoresizingMaskIntoConstraints = false
        vertical.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        vertical.widthAnchor.constraint(equalTo: self.tdView.widthAnchor, multiplier: 14 / 375).isActive = true
        vertical.topAnchor.constraint(equalTo: self.tdView.topAnchor).isActive = true
        vertical.bottomAnchor.constraint(equalTo: self.tdView.bottomAnchor).isActive = true
        
        let label = UILabel.init()
        label.text = "Today's Devotional"
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textColor = color
        label.textAlignment = .right
        self.tdView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.trailingAnchor.constraint(equalTo: vertical.leadingAnchor, constant: -11).isActive = true
        label.topAnchor.constraint(equalTo: self.tdView.topAnchor).isActive = true
        
        let shareButton = UIButton.init()
        shareButton.setImage(UIImage.init(named: "share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.addTarget(self, action: #selector(self.shareTD(_:)), for: .touchUpInside)
        self.tdView.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.leadingAnchor.constraint(equalTo: self.tdView.leadingAnchor, constant: 29).isActive = true
        shareButton.topAnchor.constraint(equalTo: self.tdView.topAnchor, constant: 7).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor, multiplier: 1.0).isActive = true
        
        self.tdTitleLabel = UILabel.init()
        self.tdTitleLabel.text = "title"
        self.tdTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        self.tdTitleLabel.textColor = color
        self.tdTitleLabel.numberOfLines = 0
        self.tdTitleLabel.textAlignment = .right
        self.tdView.addSubview(self.tdTitleLabel)
        self.tdTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tdTitleLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        self.tdTitleLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        self.tdTitleLabel.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 30).isActive = true
        
        self.tdAuthorLabel = UILabel.init()
        self.tdAuthorLabel.text = "author"
        self.tdAuthorLabel.textColor = color
        self.tdAuthorLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.tdAuthorLabel.numberOfLines = 0
        self.tdAuthorLabel.textAlignment = .right
        self.tdView.addSubview(self.tdAuthorLabel)
        self.tdAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tdAuthorLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        self.tdAuthorLabel.topAnchor.constraint(equalTo: self.tdTitleLabel.bottomAnchor, constant: 7).isActive = true
        self.tdAuthorLabel.leadingAnchor.constraint(equalTo: self.tdTitleLabel.leadingAnchor, constant: 20).isActive = true
        
        let seperator = self.seperator
        self.tdView.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.leadingAnchor.constraint(equalTo: self.tdView.leadingAnchor, constant: 16).isActive = true
        seperator.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: self.tdAuthorLabel.bottomAnchor, constant: 8).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.tdContentLabel = UILabel.init()
        var content_attributes = self.contentAttributes
        content_attributes[NSAttributedString.Key.foregroundColor] = color
        self.tdContentLabel.attributedText = NSAttributedString.init(string: "content", attributes: self.contentAttributes)
        self.tdContentLabel.numberOfLines = 0
        self.tdView.addSubview(self.tdContentLabel)
        self.tdContentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tdContentLabel.leadingAnchor.constraint(equalTo: seperator.leadingAnchor).isActive = true
        self.tdContentLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        self.tdContentLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 5).isActive = true
        
        self.td_spinner = UIActivityIndicatorView.init(style: .gray)
        self.td_spinner?.translatesAutoresizingMaskIntoConstraints = false
        self.td_spinner?.startAnimating()
        self.tdView.addSubview(self.td_spinner!)

        self.td_spinner?.centerXAnchor.constraint(equalTo: self.tdView.centerXAnchor).isActive = true
        self.td_spinner?.centerYAnchor.constraint(equalTo: self.tdView.centerYAnchor).isActive = true
        
        NetworkManager.register(target: self, selector: #selector(self.updateTodaysDevotional(_:)), dataType: .todaysDevotional)
    }
    
    @objc func updateTodaysDevotional(_ td: [String: Any]) {
        guard
            let title = (td["title HTML"] as? String)?.attributedStringFromHTMLString.string,
            let content = (td["content HTML"] as? String)?.mutableAttributedStringFromHTMLString,
            let author = (td["author HTML"] as? String)?.attributedStringFromHTMLString.string
//            let aboutAuthor = (td["about author HTML"] as? String)?.mutableAttributedStringFromHTMLString,
//            let citation = (td["citation HTML"] as? String)?.attributedStringFromHTMLString,
//            let date = td["date"] as? Date
        else {
            return
        }
        DispatchQueue.main.async {
            self.td_spinner?.stopAnimating()
            self.td_spinner?.removeFromSuperview()
            self.tdTitleLabel.text = title
            self.tdAuthorLabel.text = author
            self.configureContentAttributes(content)
            self.tdContentLabel.attributedText = content
            self.tdView.layoutIfNeeded()
            self.tdViewHeightConstraint.constant = self.tdContentLabel.frame.maxY
            self.scrollView.layoutIfNeeded()
            self.scrollView.contentSize = .init(width: self.scrollView.bounds.width, height: self.tdView.frame.maxY + 20)
        }
    }
    
    @objc func shareTD(_ sender: UIButton) {
        if let snapshot = self.votdView.snapshotView(afterScreenUpdates: true) {
            let image = snapshot.renderedImage
            let alertController = UIAlertController.init(title: "Share Today's Devotional", message: "An image of the \"Today's Devotional\" section is created for you.", preferredStyle: .alert)
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
    
    fileprivate func configureContentAttributes(_ content: NSMutableAttributedString) {
        var color = UIColor.black.withAlphaComponent(0.7)
        if #available(iOS 13, *) {
            color = UIColor.label.withAlphaComponent(0.7)
        }
        content.setFontFace(font: UIFont.systemFont(ofSize: 17, weight: .light), color: color)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.firstLineHeadIndent = 34
        content.addAttribute(.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: content.length))
    }
    
    var contentAttributes: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7),
        ]
    }
    
}

