//
//  PostcardView+Layout.swift
//  Holy Bible
//
//  Created by Jun Ke on 7/20/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import LTMorphingLabel
import UIKit

extension PostcardView {
    
    public func layoutStartScene() {
        coverImageView = UIImageView.init(frame: .init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width / 375 * 195))
        coverImageView.image = UIImage.init(named: "postcard 1")
        postcardBackgroundView.addSubview(coverImageView)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageViewTopConstraint = coverImageView.topAnchor.constraint(equalTo: postcardBackgroundView.topAnchor)
        coverImageViewTopConstraint.isActive = true
        coverImageViewLeadingConstraint = coverImageView.leadingAnchor.constraint(equalTo: postcardBackgroundView.leadingAnchor)
        coverImageViewLeadingConstraint.isActive = true
        coverImageViewTrailingConstraint = coverImageView.trailingAnchor.constraint(equalTo: postcardBackgroundView.trailingAnchor)
        coverImageViewTrailingConstraint.isActive = true
        coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 195 / 375).isActive = true
        
        postcardBottomView = UIImageView.init(frame: .init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width / 375 * 68))
        postcardBottomView.image = UIImage.init(named: "portcard bottom")
        postcardBackgroundView.addSubview(postcardBottomView)
        postcardBottomView.translatesAutoresizingMaskIntoConstraints = false
        postcardBottomView.leadingAnchor.constraint(equalTo: postcardBackgroundView.leadingAnchor).isActive = true
        postcardBottomView.trailingAnchor.constraint(equalTo: postcardBackgroundView.trailingAnchor).isActive = true
        postcardBottomView.bottomAnchor.constraint(equalTo: postcardBackgroundView.bottomAnchor).isActive = true
        postcardBottomView.heightAnchor.constraint(equalTo: postcardBottomView.widthAnchor, multiplier: 68 / 375).isActive = true
        
        lineView = UIView.init(frame: .init(x: 0, y: 0, width: 100, height: 2))
        lineView.backgroundColor = UIColor.clear
        lineView.layer.cornerRadius = 1
        postcardBackgroundView.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.leadingAnchor.constraint(equalTo: postcardBackgroundView.leadingAnchor, constant: 20).isActive = true
        lineView.trailingAnchor.constraint(equalTo: postcardBackgroundView.trailingAnchor, constant: -20).isActive = true
        lineView.bottomAnchor.constraint(equalTo: postcardBottomView.topAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        cancelButton = UIButton.init()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.init(hex: "D0021B"), for: .normal)
        cancelButton.alpha = 0
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTouchUpInside(_:)), for: .touchUpInside)
        postcardBackgroundView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leadingAnchor.constraint(equalTo: postcardBackgroundView.leadingAnchor, constant: 25).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: postcardBottomView.centerYAnchor).isActive = true
        
        nextButton = UIButton.init()
        nextButton.setTitle("Start", for: .normal)
        nextButton.setTitle("down", for: .focused)
        nextButton.setTitleColor(UIColor.init(hex: "4A4A4A"), for: .normal)
        nextButton.alpha = 0
        nextButton.addTarget(self, action: #selector(self.nextButtonTouchUpInside(_:)), for: .touchUpInside)
        nextButton.sizeToFit()
        postcardBackgroundView.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: postcardBottomView.centerYAnchor).isActive = true
        
        itsEasyLabel = UILabel.init()
        itsEasyLabel.text = "IT'S EASY"
        itsEasyLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        itsEasyLabel.textColor = UIColor.white
        itsEasyLabel.alpha = 0
        postcardBackgroundView.addSubview(itsEasyLabel)
        itsEasyLabel.translatesAutoresizingMaskIntoConstraints = false
        itsEasyLabel.leadingAnchor.constraint(equalTo: postcardBackgroundView.leadingAnchor, constant: 15).isActive = true
        itsEasyLabel.topAnchor.constraint(equalTo: postcardBackgroundView.topAnchor, constant: 20).isActive = true
        
        firstStepLabel = UILabel.init()
        firstStepLabel.text = "✟ Include a Piece of the Word of God."
        firstStepLabel.textColor = UIColor.white
        firstStepLabel.font = UIFont.systemFont(ofSize: 14)
        firstStepLabel.alpha = 0
        postcardBackgroundView.addSubview(firstStepLabel)
        firstStepLabel.translatesAutoresizingMaskIntoConstraints = false
        firstStepLabel.leadingAnchor.constraint(equalTo: itsEasyLabel.leadingAnchor).isActive = true
        firstStepLabel.topAnchor.constraint(equalTo: itsEasyLabel.bottomAnchor, constant: 20).isActive = true
        
        secondStepLabel = UILabel.init()
        secondStepLabel.text = "♡ Write a Words of Your Own."
        secondStepLabel.font = UIFont.systemFont(ofSize: 14)
        secondStepLabel.textColor = UIColor.white
        secondStepLabel.alpha = 0
        postcardBackgroundView.addSubview(secondStepLabel)
        secondStepLabel.translatesAutoresizingMaskIntoConstraints = false
        secondStepLabel.leadingAnchor.constraint(equalTo: itsEasyLabel.leadingAnchor).isActive = true
        secondStepLabel.topAnchor.constraint(equalTo: firstStepLabel.bottomAnchor, constant: 10).isActive = true
        
        thirdStepLabel = UILabel.init()
        thirdStepLabel.text = "↳ Share it the way you like."
        thirdStepLabel.textColor = UIColor.white
        thirdStepLabel.font = UIFont.systemFont(ofSize: 14)
        thirdStepLabel.alpha = 0
        postcardBackgroundView.addSubview(thirdStepLabel)
        thirdStepLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdStepLabel.leadingAnchor.constraint(equalTo: itsEasyLabel.leadingAnchor).isActive = true
        thirdStepLabel.topAnchor.constraint(equalTo: secondStepLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    public func layoutChooseVerseScene() {
        titleLabel = LTMorphingLabel.init()
        titleLabel.morphingEffect = .scale
        titleLabel.text = chooseVerseTitle
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        titleLabel.alpha = 0
        postcardBackgroundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: postcardBackgroundView.leadingAnchor, constant: self.bounds.width + 20)
        titleLabelLeadingConstraint.isActive = true
        titleLabel.topAnchor.constraint(equalTo: postcardBackgroundView.topAnchor, constant: 20).isActive = true
        
        chooseButton = UIButton.init()
        chooseButton.setTitle("CHOOSE A VERSE", for: .normal)
        chooseButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        chooseButton.setTitleColor(UIColor.init(white: 0, alpha: 0.7), for: .normal)
        chooseButton.addTarget(self, action: #selector(self.chooseVerseButtonTouchUpInside(_:)), for: .touchUpInside)
        chooseButton.alpha = 0
        postcardBackgroundView.addSubview(chooseButton)
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        chooseButtonCenterXConstraint = chooseButton.centerXAnchor.constraint(equalTo: postcardBackgroundView.centerXAnchor, constant: self.bounds.width)
        chooseButtonCenterXConstraint.isActive = true
        chooseButton.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -3).isActive = true
        
        mark16SourceLabel = UILabel.init()
        mark16SourceLabel.text = "Mark 16:15 KJV"
        mark16SourceLabel.font = UIFont.systemFont(ofSize: 14)
        mark16SourceLabel.textColor = UIColor.init(hex: "9B9B9B")
        mark16SourceLabel.alpha = 0
        postcardBackgroundView.addSubview(mark16SourceLabel)
        mark16SourceLabel.translatesAutoresizingMaskIntoConstraints = false
        mark16SourceLabel.bottomAnchor.constraint(equalTo: chooseButton.topAnchor, constant: -5).isActive = true
        mark16SourceLabelTrailingConstraint = mark16SourceLabel.trailingAnchor.constraint(equalTo: postcardBackgroundView.trailingAnchor, constant: -34 + self.bounds.width)
        mark16SourceLabelTrailingConstraint.isActive = true
        
        mark16Label = UILabel.init()
        mark16Label.text = "And he said unto them, Go ye into all the world, and preach the gospel to every creature."
        mark16Label.font = UIFont.italicSystemFont(ofSize: 14)
        mark16Label.textColor = UIColor.init(hex: "9B9B9B")
        mark16Label.numberOfLines = 0
        mark16Label.alpha = 0
        postcardBackgroundView.addSubview(mark16Label)
        mark16Label.translatesAutoresizingMaskIntoConstraints = false
        mark16LabelLeadingConstraint = mark16Label.leadingAnchor.constraint(equalTo: postcardBackgroundView.leadingAnchor, constant: 34 + self.bounds.width)
        mark16LabelLeadingConstraint.isActive = true
        mark16LabelTrailingConstraint = mark16Label.trailingAnchor.constraint(equalTo: postcardBackgroundView.trailingAnchor, constant: -34 + self.bounds.width)
        mark16LabelTrailingConstraint.isActive = true
        mark16Label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        mark16Label.bottomAnchor.constraint(equalTo: mark16SourceLabel.topAnchor, constant: -5).isActive = true
    }
    
    public func layoutOwnWordsScene() {
        textViewContainer = UIView.init()
        textViewContainer.backgroundColor = UIColor.init(hex: "F3F3F3")
        textViewContainer.layer.shadowOpacity = 0.5
        textViewContainer.layer.shadowColor = UIColor.black.cgColor
        textViewContainer.layer.shadowOffset = CGSize.zero
        textViewContainer.layer.shadowRadius = 1
        postcardBackgroundView.addSubview(textViewContainer)
        textViewContainer.translatesAutoresizingMaskIntoConstraints = false
        textViewContainer.leadingAnchor.constraint(equalTo: postcardBackgroundView.leadingAnchor, constant: 20).isActive = true
        textViewContainer.trailingAnchor.constraint(equalTo: postcardBackgroundView.trailingAnchor, constant: -20).isActive = true
        textViewContainerTopConstraint = textViewContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10 + self.bounds.height)
        textViewContainerTopConstraint.isActive = true
        textViewContainerBottomConstraint = textViewContainer.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -5 + self.bounds.height)
        textViewContainerBottomConstraint.isActive = true
        indicatorScrollView = UIScrollView.init()
        indicatorScrollView.isUserInteractionEnabled = false
        textViewContainer.addSubview(indicatorScrollView)
        indicatorScrollView.translatesAutoresizingMaskIntoConstraints = false
        indicatorScrollView.leadingAnchor.constraint(equalTo: textViewContainer.leadingAnchor, constant: 7).isActive = true
        indicatorScrollView.widthAnchor.constraint(equalToConstant: 5).isActive = true
        indicatorScrollView.topAnchor.constraint(equalTo: textViewContainer.topAnchor, constant: 5).isActive = true
        indicatorScrollView.bottomAnchor.constraint(equalTo: textViewContainer.bottomAnchor).isActive = true
        
        textView = UITextView.init()
        textView.backgroundColor = UIColor.clear
        textView.text = textViewPlaceHolder
        textView.textColor = UIColor.lightGray
        textView.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        textView.delegate = self
        textViewContainer.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: indicatorScrollView.trailingAnchor, constant: 10).isActive = true
        textView.topAnchor.constraint(equalTo: textViewContainer.topAnchor, constant: 7).isActive = true
        textView.trailingAnchor.constraint(equalTo: textViewContainer.trailingAnchor, constant: -5).isActive = true
        textView.bottomAnchor.constraint(equalTo: textViewContainer.bottomAnchor, constant: -5).isActive = true
    }
    
    public func layoutShareScene() {
        shareButtonsPadding = 30
        shareButtonCellWidth = (self.bounds.width - 2 * shareButtonsPadding) / 4
        
        facebookButton = UIButton.init()
        facebookButton.tag = 1000
        facebookButton.alpha = 0
        facebookButton.setImage(UIImage.init(named: "facebook icon"), for: .normal)
        facebookButton.addTarget(self, action: #selector(self.shareButtonPressed(_:)), for: .touchUpInside)
        self.addSubview(facebookButton)
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButtonCenterXConstraint = facebookButton.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: shareButtonsPadding + shareButtonCellWidth / 2 + self.bounds.width)
        facebookButtonCenterXConstraint.isActive = true
        facebookButton.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35).isActive = true
        
        instagramButton = UIButton.init()
        instagramButton.tag = 1001
        instagramButton.setImage(UIImage.init(named: "instagram icon"), for: .normal)
        instagramButton.addTarget(self, action: #selector(self.shareButtonPressed(_:)), for: .touchUpInside)
        instagramButton.alpha = 0
        self.addSubview(instagramButton)
        instagramButton.translatesAutoresizingMaskIntoConstraints = false
        instagramButtonCenterXConstraint = instagramButton.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: shareButtonsPadding + shareButtonCellWidth * 3 / 2 + self.bounds.width)
        instagramButtonCenterXConstraint.isActive = true
        instagramButton.centerYAnchor.constraint(equalTo: facebookButton.centerYAnchor).isActive = true
        
        messengerButton = UIButton.init()
        messengerButton.tag = 1002
        messengerButton.setImage(UIImage.init(named: "messenger icon"), for: .normal)
        messengerButton.addTarget(self, action: #selector(self.shareButtonPressed(_:)), for: .touchUpInside)
        messengerButton.alpha = 0
        self.addSubview(messengerButton)
        messengerButton.translatesAutoresizingMaskIntoConstraints = false
        messengerButtonCenterXConstraint = messengerButton.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: shareButtonsPadding + shareButtonCellWidth * 5 / 2 + self.bounds.width)
        messengerButtonCenterXConstraint.isActive = true
        messengerButton.centerYAnchor.constraint(equalTo: facebookButton.centerYAnchor).isActive = true
        
        whatsAppButton = UIButton.init()
        whatsAppButton.tag = 1003
        whatsAppButton.setImage(UIImage.init(named: "whatsapp icon"), for: .normal)
        whatsAppButton.addTarget(self, action: #selector(self.shareButtonPressed(_:)), for: .touchUpInside)
        whatsAppButton.alpha = 0
        self.addSubview(whatsAppButton)
        whatsAppButton.translatesAutoresizingMaskIntoConstraints = false
        whatsAppButtonCenterXConstraint = whatsAppButton.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: shareButtonsPadding + shareButtonCellWidth * 7 / 2 + self.bounds.width)
        whatsAppButtonCenterXConstraint.isActive = true
        whatsAppButton.centerYAnchor.constraint(equalTo: facebookButton.centerYAnchor).isActive = true
        
        twitterButton = UIButton.init()
        twitterButton.tag = 1004
        twitterButton.setImage(UIImage.init(named: "twitter icon"), for: .normal)
        twitterButton.addTarget(self, action: #selector(self.shareButtonPressed(_:)), for: .touchUpInside)
        twitterButton.alpha = 0
        self.addSubview(twitterButton)
        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        twitterButton.centerXAnchor.constraint(equalTo: facebookButton.centerXAnchor, constant: 0).isActive = true
        twitterButton.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 20).isActive = true
        
        wechatButton = UIButton.init()
        wechatButton.tag = 1005
        wechatButton.setImage(UIImage.init(named: "wechat icon"), for: .normal)
        wechatButton.addTarget(self, action: #selector(self.shareButtonPressed(_:)), for: .touchUpInside)
        wechatButton.alpha = 0
        self.addSubview(wechatButton)
        wechatButton.translatesAutoresizingMaskIntoConstraints = false
        wechatButton.centerXAnchor.constraint(equalTo: instagramButton.centerXAnchor).isActive = true
        wechatButton.centerYAnchor.constraint(equalTo: twitterButton.centerYAnchor).isActive = true
        
        qqButton = UIButton.init()
        qqButton.tag = 1006
        qqButton.setImage(UIImage.init(named: "qq icon"), for: .normal)
        qqButton.addTarget(self, action: #selector(self.shareButtonPressed(_:)), for: .touchUpInside)
        qqButton.alpha = 0
        self.addSubview(qqButton)
        qqButton.translatesAutoresizingMaskIntoConstraints = false
        qqButton.centerXAnchor.constraint(equalTo: messengerButton.centerXAnchor).isActive = true
        qqButton.centerYAnchor.constraint(equalTo: twitterButton.centerYAnchor).isActive = true
        
        weiboButton = UIButton.init()
        weiboButton.tag = 1007
        weiboButton.setImage(UIImage.init(named: "sina weibo icon"), for: .normal)
        weiboButton.addTarget(self, action: #selector(self.shareButtonPressed(_:)), for: .touchUpInside)
        weiboButton.alpha = 0
        self.addSubview(weiboButton)
        weiboButton.translatesAutoresizingMaskIntoConstraints = false
        weiboButton.centerXAnchor.constraint(equalTo: whatsAppButton.centerXAnchor).isActive = true
        weiboButton.centerYAnchor.constraint(equalTo: twitterButton.centerYAnchor).isActive = true
    }
    
}

