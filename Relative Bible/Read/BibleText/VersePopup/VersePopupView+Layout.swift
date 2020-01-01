//
//  VersePopupView+Layout.swift
//  Bible
//
//  Created by Jun Ke on 8/13/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension VersePopupView {
    
    fileprivate func createActionsScrollView(alignTop: NSLayoutYAxisAnchor) {
        self.actionScrollView = UIScrollView.init()
        self.actionScrollView.contentInset = .init(top: 0, left: 23, bottom: 0, right: 23)
        self.actionScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.actionScrollView)
        self.actionScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.actionScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.actionScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.actionScrollView.topAnchor.constraint(equalTo: alignTop, constant: 10).isActive = true
        self.actionScrollView.heightAnchor.constraint(equalToConstant: self.actionScrollViewHeight).isActive = true
        
        let images = [
            UserData.isLiked(book: self.verse.book, chapter: self.verse.chapter, verse: self.verse.verseNum) ? UIImage.init(named: "like") : UIImage.init(named: "like hallow"),
            UIImage.init(named: "scissors"),
            UIImage.init(named: "share")
//            UIImage.init(named: "postcard plain"),
//            UIImage.init(named: "qq icon"),
//            UIImage.init(named: "facebook icon"),
//            UIImage.init(named: "instagram icon"),
//            UIImage.init(named: "messenger icon"),
//            UIImage.init(named: "twitter icon"),
//            UIImage.init(named: "wechat icon")
        ]
        let selectors = [
        #selector(self.likeButtonTouchUpInside(_:)),
        #selector(self.copyButtonTouchUpInside(_:)),
        #selector(self.shareButtonTouchUpInside(_:))
//        #selector(self.postcardTapped(_:)),
//        #selector(self.shareWithQQ(_:)),
//        #selector(self.shareWithFacebook(_:)),
//        #selector(self.shareWithInstagram(_:)),
//        #selector(self.shareWithMessenger(_:)),
//        #selector(self.shareWithTwitter(_:)),
//        #selector(self.shareWithWeChat(_:))
        ]
        let imageSizes = [
            CGSize.init(width: 27, height: 24.55),
            CGSize.init(width: 27, height: 24),
            CGSize.init(width: 32, height: 32)
//            CGSize.init(width: 37.2, height: 25.85),
//            CGSize.init(width: 25.5, height: 30),
//            CGSize.init(width: 30, height: 30),
//            CGSize.init(width: 30, height: 30),
//            CGSize.init(width: 30, height: 30),
//            CGSize.init(width: 30, height: 30),
//            CGSize.init(width: 30, height: 24.84)
        ]
        
        var containers: [UIView] = []
        for (n, image) in images.enumerated() {
            let container = UIView.init()
            container.backgroundColor = UIColor.black.withAlphaComponent(0.05)
            container.layer.cornerRadius = 8
            containers.append(container)
            let button = UIButton.init()
            button.setImage(image, for: .normal)
            button.addTarget(self, action: selectors[n], for: .touchUpInside)
            container.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: imageSizes[n].width).isActive = true
            button.heightAnchor.constraint(equalToConstant: imageSizes[n].height).isActive = true
        }
        for (n, container) in containers.enumerated() {
            actionScrollView.addSubview(container)
            container.translatesAutoresizingMaskIntoConstraints = false
            container.leadingAnchor.constraint(equalTo: actionScrollView.leadingAnchor, constant: CGFloat(n % 5) * (self.actionScrollViewHorizontalPadding + self.actionScrollViewButtonSize.width)).isActive = true
            container.topAnchor.constraint(equalTo: actionScrollView.topAnchor, constant: CGFloat(n / 5) * (self.actionScrollViewVerticalPadding + self.actionScrollViewButtonSize.height)).isActive = true
            container.widthAnchor.constraint(equalToConstant: self.actionScrollViewButtonSize.width).isActive = true
            container.heightAnchor.constraint(equalToConstant: self.actionScrollViewButtonSize.height).isActive = true
        }
        
        self.actionScrollView.layoutIfNeeded()
        self.actionScrollView.contentSize = CGSize.init(width: containers.last!.frame.maxX, height: self.actionScrollViewHeight)
    }
    
    fileprivate func createColorScrollView(alignTop: NSLayoutYAxisAnchor) {
        self.highlightScrollView = UIScrollView.init()
        self.highlightScrollView.contentInset = .init(top: 0, left: 23, bottom: 0, right: 23)
        self.highlightScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.highlightScrollView)
        self.highlightScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.highlightScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.highlightScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.highlightScrollView.topAnchor.constraint(equalTo: alignTop, constant: 10).isActive = true
        self.highlightScrollView.heightAnchor.constraint(equalToConstant: self.highlightScrollViewHeight).isActive = true
        
        var lastButton: UIButton? = nil
        for (n, hex) in VersePopupView.highlightColorsHex.enumerated() {
            let button = UIButton.init()
            if hex == "FFFFFF" {
                button.backgroundColor = UIColor.white
                button.setTitle("T", for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .medium)
            } else {
                button.backgroundColor = UIColor.init(hex: hex)
                button.setTitle("T", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .medium)
                button.layer.borderWidth = 3
                button.layer.borderColor = UIColor.white.cgColor
            }
            button.addTarget(self, action: #selector(self.highlightSampleTouchUpInside(_:)), for: .touchUpInside)
            highlightScrollView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leadingAnchor.constraint(equalTo: self.highlightScrollView.leadingAnchor, constant: CGFloat(n) * (self.highlightScrollViewHeight + self.highlighScrollViewHorizontalPadding)).isActive = true
            button.topAnchor.constraint(equalTo: self.highlightScrollView.topAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: self.highlightScrollViewHeight).isActive = true
            button.heightAnchor.constraint(equalToConstant: self.highlightScrollViewHeight).isActive = true
            lastButton = button
        }
        
        self.highlightScrollView.layoutIfNeeded()
        self.highlightScrollView.contentSize = CGSize.init(width: lastButton!.frame.maxX, height: self.highlightScrollViewHeight)
    }
    
    fileprivate var actionScrollViewHeight: CGFloat {
        return 65
    }
    
    fileprivate var actionScrollViewButtonSize: CGSize {
        return .init(width: 62, height: 62)
    }
    
    fileprivate var actionScrollViewVerticalPadding: CGFloat {
        return 13
    }
    
    fileprivate var actionScrollViewHorizontalPadding: CGFloat {
        return 14
    }
    
    fileprivate var highlightScrollViewHeight: CGFloat {
        return 50
    }
    
    fileprivate var highlighScrollViewHorizontalPadding: CGFloat {
        return 7
    }
    
    func layout() {
        self.backgroundColor = UIColor.barTintColor
        
        self.verseLabel = UILabel.init()
        self.verseLabel.text = self.verse.translatedDescription(ofVersion: ReadViewController.version) + " " + self.verse.version.rawValue
        self.verseLabel.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        self.verseLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
        self.addSubview(self.verseLabel)
        self.verseLabel.translatesAutoresizingMaskIntoConstraints = false
        self.verseLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        self.verseLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.verseLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        
        self.contentLabel = UILabel.init()
        self.contentLabel.text = self.verse.content
        self.contentLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.contentLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
        self.contentLabel.numberOfLines = 0
        self.addSubview(self.contentLabel)
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        self.contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        self.contentLabel.topAnchor.constraint(equalTo: self.verseLabel.bottomAnchor, constant: 15).isActive = true
        
        let seperator1 = self.seperator
        self.addSubview(seperator1)
        seperator1.translatesAutoresizingMaskIntoConstraints = false
        seperator1.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        seperator1.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        seperator1.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor, constant: 15).isActive = true
        seperator1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.createActionsScrollView(alignTop: seperator1.bottomAnchor)
        
        let seperator2 = self.seperator
        self.addSubview(seperator2)
        seperator2.translatesAutoresizingMaskIntoConstraints = false
        seperator2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28).isActive = true
        seperator2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28).isActive = true
        seperator2.topAnchor.constraint(equalTo: self.actionScrollView.bottomAnchor, constant: 15).isActive = true
        seperator2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let highlightLabel = UILabel.init()
        highlightLabel.text = "Highlight"
        highlightLabel.textColor = UIColor.black.withAlphaComponent(0.7)
        highlightLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        self.addSubview(highlightLabel)
        highlightLabel.translatesAutoresizingMaskIntoConstraints = false
        highlightLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        highlightLabel.topAnchor.constraint(equalTo: seperator2.bottomAnchor, constant: 10).isActive = true
        
        self.createColorScrollView(alignTop: highlightLabel.bottomAnchor)
        
        let seperator3 = self.seperator
        self.addSubview(seperator3)
        seperator3.translatesAutoresizingMaskIntoConstraints = false
        seperator3.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        seperator3.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        seperator3.topAnchor.constraint(equalTo: self.highlightScrollView.bottomAnchor, constant: 15).isActive = true
        seperator3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.cancelButton = UIButton.init()
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonTouchUpInside(_:)), for: .touchUpInside)
        self.cancelButton.setTitleColor(UIColor.red, for: .normal)
        self.cancelButton.setTitleColor(UIColor.init(hex: "CC372F"), for: .focused)
        self.addSubview(self.cancelButton)
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.cancelButton.topAnchor.constraint(equalTo: seperator3.bottomAnchor).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.layoutIfNeeded()

        self.frame = .init(x: 0, y: 100, width: self.bounds.width, height: self.cancelButton.frame.maxY)
        
//        self.scrollIndicator = UIView.init()
//        self.scrollIndicator.backgroundColor = UIColor.init(hex: "555555")
//        self.scrollIndicator.layer.cornerRadius = 2
//        self.scrollIndicator.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(self.scrollIndicatorPanRecognized(_:))))
//        self.addSubview(self.scrollIndicator)
//        self.scrollIndicator.translatesAutoresizingMaskIntoConstraints = false
//        self.scrollIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        self.scrollIndicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
//        self.scrollIndicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        self.scrollIndicator.heightAnchor.constraint(equalToConstant: 6).isActive = true
//
//        self.promptLabel = UILabel.init()
//        self.promptLabel.text = self.promptTexts[self.currentPrompt]
//        self.promptLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
//        self.promptLabel.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
//        self.promptLabel.textAlignment = .center
//        self.addSubview(self.promptLabel)
//        self.promptLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.promptLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//        self.promptLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
//        self.promptLabel.topAnchor.constraint(equalTo: self.scrollIndicator.bottomAnchor, constant: 12).isActive = true
//
//        self.scrollView = UIScrollView.init()
//        self.addSubview(self.scrollView)
//        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
//        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        self.scrollView.topAnchor.constraint(equalTo: self.promptLabel.bottomAnchor, constant: 12).isActive = true
//        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//
//        self.copyButton = UIButton.init()
//        self.copyButton.setTitle("Copy", for: .normal)
//        self.copyButton.setTitleColor(UIColor.init(white: 0, alpha: 0.7), for: .normal)
//        self.copyButton.setImage(UIImage.init(named: "scissors"), for: .normal)
//        self.copyButton.addTarget(self, action: #selector(self.copyButtonTouchUpInside(_:)), for: .touchUpInside)
//        self.copyButton.layer.cornerRadius = 9
//        self.copyButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
//        self.copyButton.layer.borderWidth = 1
//        self.copyButton.layer.borderColor = UIColor.init(hex: "D7D7D7").withAlphaComponent(0.5).cgColor
//        self.copyButton.backgroundColor = UIColor.init(hex: "EDEDED")
//        self.scrollView.addSubview(self.copyButton)
//        self.copyButton.translatesAutoresizingMaskIntoConstraints = false
//        self.copyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
//        self.copyButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        self.copyButton.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
//        self.copyButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 134 / 375).isActive = true
//
//        self.likeButton = UIButton.init()
//        self.likeButton.setTitle("Like", for: .normal)
//        self.likeButton.setTitleColor(UIColor.init(white: 0, alpha: 0.7), for: .normal)
//        self.likeButton.setImage(UIImage.init(named: "like hallow"), for: .normal)
//        self.likeButton.addTarget(self, action: #selector(self.likeButtonTouchUpInside(_:)), for: .touchUpInside)
//        self.likeButton.layer.cornerRadius = 9
//        self.likeButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
//        self.likeButton.layer.borderWidth = 1
//        self.likeButton.layer.borderColor = UIColor.init(hex: "D7D7D7").withAlphaComponent(0.5).cgColor
//        self.likeButton.backgroundColor = UIColor.init(hex: "EDEDED")
//        self.scrollView.addSubview(self.likeButton)
//        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
//        self.likeButton.trailingAnchor.constraint(equalTo: self.copyButton.leadingAnchor, constant: -4).isActive = true
//        self.likeButton.heightAnchor.constraint(equalTo: self.copyButton.heightAnchor, multiplier: 1.0).isActive = true
//        self.likeButton.widthAnchor.constraint(equalTo: self.copyButton.widthAnchor, multiplier: 1.0).isActive = true
//        self.likeButton.topAnchor.constraint(equalTo: self.copyButton.topAnchor).isActive = true
//
//        self.shareButton = UIButton.init()
//        self.shareButton.setImage(UIImage.init(named: "share"), for: .normal)
//        self.shareButton.contentHorizontalAlignment = .center
//        self.shareButton.addTarget(self, action: #selector(self.shareButtonTouchUpInside(_:)), for: .touchUpInside)
//        self.scrollView.addSubview(self.shareButton)
//        self.shareButton.translatesAutoresizingMaskIntoConstraints = false
//        self.shareButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        self.shareButton.trailingAnchor.constraint(equalTo: self.likeButton.leadingAnchor).isActive = true
//        self.shareButton.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
//
//        let seperator1 = self.seperator
//        seperator1.layer.cornerRadius = 1
//        self.scrollView.addSubview(seperator1)
//        seperator1.translatesAutoresizingMaskIntoConstraints = false
//        seperator1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 36).isActive = true
//        seperator1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -36).isActive = true
//        seperator1.topAnchor.constraint(equalTo: self.likeButton.bottomAnchor, constant: 12).isActive = true
//        seperator1.heightAnchor.constraint(equalToConstant: 2).isActive = true
//
//        let leadingOffset: CGFloat = 20
//
//        let gospelContainer = self.paddedContainer
//        self.scrollView.addSubview(gospelContainer)
//        gospelContainer.translatesAutoresizingMaskIntoConstraints = false
//        gospelContainer.leadingAnchor.constraint(lessThanOrEqualTo: self.leadingAnchor, constant: leadingOffset).isActive = true
//        gospelContainer.topAnchor.constraint(equalTo: seperator1.bottomAnchor, constant: 12).isActive = true
//        gospelContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 140/375, constant: 0).isActive = true
//        gospelContainer.heightAnchor.constraint(equalToConstant: 128).isActive = true
//
//        self.postcardImageView = UIImageView.init()
//        self.postcardImageView.image = UIImage.init(named: "postcard plain")
//        self.postcardImageView.contentMode = .scaleAspectFit
//        self.postcardImageView.layer.shadowColor = UIColor.black.cgColor
//        self.postcardImageView.layer.shadowOpacity = 0.5
//        self.postcardImageView.layer.shadowOffset = .init(width: 0, height: 2)
//        self.postcardImageView.layer.shadowRadius = 4
//        self.postcardImageView.isUserInteractionEnabled = true
//        self.postcardImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.postcardTapped(_:))))
//        gospelContainer.addSubview(self.postcardImageView)
//        self.postcardImageView.translatesAutoresizingMaskIntoConstraints = false
//        self.postcardImageView.widthAnchor.constraint(equalToConstant: 59).isActive = true
//        self.postcardImageView.heightAnchor.constraint(equalToConstant: 41).isActive = true
//        self.postcardImageView.centerXAnchor.constraint(equalTo: gospelContainer.centerXAnchor).isActive = true
//        self.postcardImageView.topAnchor.constraint(equalTo: gospelContainer.topAnchor, constant: 12).isActive = true
//
//        let postcardLabel = UILabel.init()
//        postcardLabel.text = "Send a gospel card with this verse"
//        postcardLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        postcardLabel.numberOfLines = 0
//        postcardLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
//        gospelContainer.addSubview(postcardLabel)
//        postcardLabel.translatesAutoresizingMaskIntoConstraints = false
//        postcardLabel.topAnchor.constraint(equalTo: self.postcardImageView.bottomAnchor, constant: 10).isActive = true
//        postcardLabel.leadingAnchor.constraint(equalTo: gospelContainer.leadingAnchor, constant: 12).isActive = true
//        postcardLabel.trailingAnchor.constraint(equalTo: gospelContainer.trailingAnchor, constant: -12).isActive = true
//        postcardLabel.bottomAnchor.constraint(equalTo: gospelContainer.bottomAnchor).isActive = true
//
//        let shareContainer = self.paddedContainer
//        self.scrollView.addSubview(shareContainer)
//        shareContainer.translatesAutoresizingMaskIntoConstraints = false
//        shareContainer.leadingAnchor.constraint(equalTo: gospelContainer.trailingAnchor, constant: 4).isActive = true
//        shareContainer.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: -leadingOffset).isActive = true
//        shareContainer.topAnchor.constraint(equalTo: gospelContainer.topAnchor).isActive = true
//        shareContainer.bottomAnchor.constraint(equalTo: gospelContainer.bottomAnchor).isActive = true
//
//        let shareLabel = UILabel.init()
//        shareLabel.text = "Just the verse"
//        shareLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        shareLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
//        shareContainer.addSubview(shareLabel)
//        shareLabel.translatesAutoresizingMaskIntoConstraints = false
//        shareLabel.centerXAnchor.constraint(equalTo: shareContainer.centerXAnchor).isActive = true
//        shareLabel.bottomAnchor.constraint(greaterThanOrEqualTo: shareContainer.bottomAnchor, constant: -10).isActive = true
//
//        self.layoutShareButtons(container: shareContainer)
//
//        let seperator2 = self.seperator
//        seperator2.layer.cornerRadius = 1
//        self.scrollView.addSubview(seperator2)
//        seperator2.translatesAutoresizingMaskIntoConstraints = false
//        seperator2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 36).isActive = true
//        seperator2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -36).isActive = true
//        seperator2.topAnchor.constraint(equalTo: gospelContainer.bottomAnchor, constant: 12).isActive = true
//        seperator2.heightAnchor.constraint(equalToConstant: 2).isActive = true
//
//        let hightlightContainer = self.paddedContainer
//        self.addSubview(hightlightContainer)
//        hightlightContainer.translatesAutoresizingMaskIntoConstraints = false
//        hightlightContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingOffset).isActive = true
//        hightlightContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -leadingOffset).isActive = true
//        hightlightContainer.topAnchor.constraint(equalTo: seperator2.bottomAnchor, constant: 12).isActive = true
//        hightlightContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
//
//        self.layoutHighlightButtons(container: hightlightContainer)
//
//        self.scrollView.layoutIfNeeded()
//        self.scrollView.contentSize = CGSize.init(width: UIScreen.main.bounds.width, height: hightlightContainer.frame.maxX + 12)
    }
//    
//    func layoutHighlightButtons(container: UIView) {
//        let highlightLabel = UILabel.init()
//        highlightLabel.text = "Highlight"
//        highlightLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
//        highlightLabel.textAlignment = .center
//        highlightLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        container.addSubview(highlightLabel)
//        highlightLabel.translatesAutoresizingMaskIntoConstraints = false
//        highlightLabel.leadingAnchor.constraint(lessThanOrEqualTo: container.leadingAnchor, constant: 12).isActive = true
//        highlightLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
//        
//        var previousSample: UIView? = nil
//        for (n, colorHex) in self.highlightColors.enumerated() {
//            let sample = UIView.init()
//            sample.backgroundColor = UIColor.init(hex: colorHex)
//            sample.layer.borderWidth = 3
//            sample.layer.borderColor = UIColor.white.cgColor
//            sample.tag = 10000 + n
//            sample.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.highlightSampleTapped(_:))))
//            let label = UILabel.init()
//            label.text = "T"
//            label.textColor = UIColor.white
//            label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//            sample.addSubview(label)
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.centerXAnchor.constraint(equalTo: sample.centerXAnchor).isActive = true
//            label.centerYAnchor.constraint(equalTo: sample.centerYAnchor).isActive = true
//            container.addSubview(sample)
//            sample.translatesAutoresizingMaskIntoConstraints = false
//            if let ps = previousSample {
//                sample.trailingAnchor.constraint(lessThanOrEqualTo: ps.leadingAnchor, constant: -7).isActive = true
//            } else {
//                sample.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12).isActive = true
//            }
//            sample.widthAnchor.constraint(equalToConstant: 27).isActive = true
//            sample.heightAnchor.constraint(equalToConstant: 27).isActive = true
//            sample.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
//            previousSample = sample
//        }
//        
////        highlightLabel.trailingAnchor.constraint(lessThanOrEqualTo: previousSample!.leadingAnchor, constant: -5).isActive = true
//    }
//    
//    func layoutShareButtons(container: UIView) {
//        let verticalSpacing: CGFloat = 12
//        let horizontalSpacing: CGFloat = 21
//        
//        let instagramButton = UIButton.init()
//        instagramButton.setImage(UIImage.init(named: "instagram icon"), for: .normal)
//        instagramButton.addTarget(self, action: #selector(self.shareWithInstagram(_:)), for: .touchUpInside)
//        container.addSubview(instagramButton)
//        instagramButton.translatesAutoresizingMaskIntoConstraints = false
//        instagramButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
//        instagramButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        instagramButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        instagramButton.topAnchor.constraint(equalTo: container.topAnchor, constant: verticalSpacing).isActive = true
//        
//        let facebookButton = UIButton.init()
//        facebookButton.setImage(UIImage.init(named: "facebook icon"), for: .normal)
//        facebookButton.addTarget(self, action: #selector(self.shareWithFacebook(_:)), for: .touchUpInside)
//        container.addSubview(facebookButton)
//        facebookButton.translatesAutoresizingMaskIntoConstraints = false
//        facebookButton.centerYAnchor.constraint(equalTo: instagramButton.centerYAnchor).isActive = true
//        facebookButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        facebookButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        facebookButton.trailingAnchor.constraint(equalTo: instagramButton.leadingAnchor, constant: -horizontalSpacing).isActive = true
//        
//        let messengerButton = UIButton.init()
//        messengerButton.setImage(UIImage.init(named: "messenger icon"), for: .normal)
//        messengerButton.addTarget(self, action: #selector(self.shareWithMessenger(_:)), for: .touchUpInside)
//        container.addSubview(messengerButton)
//        messengerButton.translatesAutoresizingMaskIntoConstraints = false
//        messengerButton.centerYAnchor.constraint(equalTo: instagramButton.centerYAnchor).isActive = true
//        messengerButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        messengerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        messengerButton.leadingAnchor.constraint(equalTo: instagramButton.trailingAnchor, constant: horizontalSpacing).isActive = true
//        
//        let wechatButton = UIButton.init()
//        wechatButton.setImage(UIImage.init(named: "wechat icon"), for: .normal)
//        wechatButton.addTarget(self, action: #selector(self.shareWithWeChat(_:)), for: .touchUpInside)
//        wechatButton.contentMode = .scaleAspectFit
//        container.addSubview(wechatButton)
//        wechatButton.translatesAutoresizingMaskIntoConstraints = false
//        wechatButton.centerXAnchor.constraint(equalTo: instagramButton.centerXAnchor).isActive = true
//        wechatButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        wechatButton.heightAnchor.constraint(equalToConstant: 24.84).isActive = true
//        wechatButton.topAnchor.constraint(equalTo: instagramButton.bottomAnchor, constant: verticalSpacing).isActive = true
//        
//        let twitterButton = UIButton.init()
//        twitterButton.setImage(UIImage.init(named: "twitter icon"), for: .normal)
//        twitterButton.addTarget(self, action: #selector(self.shareWithTwitter(_:)), for: .touchUpInside)
//        container.addSubview(twitterButton)
//        twitterButton.translatesAutoresizingMaskIntoConstraints = false
//        twitterButton.centerYAnchor.constraint(equalTo: wechatButton.centerYAnchor).isActive = true
//        twitterButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        twitterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        twitterButton.trailingAnchor.constraint(equalTo: wechatButton.leadingAnchor, constant: -horizontalSpacing).isActive = true
//        
//        let qqButton = UIButton.init()
//        qqButton.setImage(UIImage.init(named: "qq icon"), for: .normal)
//        qqButton.addTarget(self, action: #selector(self.shareWithTwitter(_:)), for: .touchUpInside)
//        container.addSubview(qqButton)
//        qqButton.translatesAutoresizingMaskIntoConstraints = false
//        qqButton.centerYAnchor.constraint(equalTo: wechatButton.centerYAnchor).isActive = true
//        qqButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        qqButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        qqButton.centerXAnchor.constraint(equalTo: messengerButton.centerXAnchor).isActive = true
//    }
    
    var seperator: UIView {
        let v = UIView.init()
        v.backgroundColor = UIColor.init(hex: "D5D5D5")
        return v
    }
    
    var paddedContainer: UIView {
        let v = UIView.init()
        v.backgroundColor = UIColor.init(hex: "EDEDED")
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.init(hex: "D7D7D7").withAlphaComponent(0.5).cgColor
        v.layer.cornerRadius = 9
        return v
    }
    
    
}

