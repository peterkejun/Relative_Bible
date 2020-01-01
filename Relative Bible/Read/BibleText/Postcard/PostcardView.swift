//
//  PostcardView.swift
//  Holy Bible
//
//  Created by Jun Ke on 7/18/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit
import LTMorphingLabel

protocol PostcardViewDelegate: class {
    func postcardViewDidRequestCancel(_ postcardView: PostcardView)
    func postcardViewDidRequestChooseVerse(_ postcardView: PostcardView)
    func postcardView(_ postcardView: PostcardView, didRequestShareWithMedia media: ShareManager.ShareMedia, verse: Verse?, words: String?)
    func postcardView(_ postcardView: PostcardView, didRequestSaveImageWithVerse verse: Verse?, words: String?)
}

class PostcardView: UIView {
    
    static let widthHeightRatio: CGFloat = 375 / 259
    
    weak var delegate: PostcardViewDelegate?
    
    public var state: State = .idle
    
    public var postcardBackgroundView: UIImageView!
    public var coverImageView: UIImageView!
    public var coverImageViewLeadingConstraint: NSLayoutConstraint!
    public var coverImageViewTrailingConstraint: NSLayoutConstraint!
    public var coverImageViewTopConstraint: NSLayoutConstraint!
    public var postcardBottomView: UIImageView!
    
    public var cancelButton: UIButton!
    public var nextButton: UIButton!
    
    //start
    public var itsEasyLabel: UILabel!
    public var firstStepLabel: UILabel!
    public var secondStepLabel: UILabel!
    public var thirdStepLabel: UILabel!
    
    //title
    public var titleLabel: LTMorphingLabel!
    public var titleLabelLeadingConstraint: NSLayoutConstraint!
    
    //choose a verse
    public var lineView: UIView!
    public var mark16Label: UILabel!
    public var mark16LabelLeadingConstraint: NSLayoutConstraint!
    public var mark16LabelTrailingConstraint: NSLayoutConstraint!
    public var mark16SourceLabel: UILabel!
    public var mark16SourceLabelTrailingConstraint: NSLayoutConstraint!
    public var chooseButton: UIButton!
    public var chooseButtonCenterXConstraint: NSLayoutConstraint!
    public var chosenVerse: Verse? {
        didSet {
            if let verse = chosenVerse, state == .chooseVerse {
                mark16Label.text = verse.content
                mark16SourceLabel.text = verse.description
                UIView.performWithoutAnimation {
                    self.nextButton.setTitle("Next", for: .normal)
                }
            }
        }
    }
    
    
    //own words
    public var textViewContainer: UIView!
    public var textViewContainerTopConstraint: NSLayoutConstraint!
    public var textViewContainerBottomConstraint: NSLayoutConstraint!
    public var textView: UITextView!
    public var ownWords: String? {
        didSet {
            if let _ = ownWords, state == .writeWords {
                UIView.performWithoutAnimation {
                    self.nextButton.setTitle("Next", for: .normal)
                }
            }
        }
    }
    public var indicatorScrollView: UIScrollView!
    
    //share
    public var facebookButton: UIButton!
    public var facebookButtonCenterXConstraint: NSLayoutConstraint!
    public var instagramButton: UIButton!
    public var instagramButtonCenterXConstraint: NSLayoutConstraint!
    public var messengerButton: UIButton!
    public var messengerButtonCenterXConstraint: NSLayoutConstraint!
    public var whatsAppButton: UIButton!
    public var whatsAppButtonCenterXConstraint: NSLayoutConstraint!
    public var twitterButton: UIButton!
    public var wechatButton: UIButton!
    public var qqButton: UIButton!
    public var weiboButton: UIButton!
    public var shareButtonsPadding: CGFloat!
    public var shareButtonCellWidth: CGFloat!
    
    public let chooseVerseTitle = "REFLECT THE WORD OF GOD ✟"
    public let ownWordsTitle = "WORDS FROM YOUR HEART ❤"
    public let shareTitle = "SHARE IT 📮"
    
//    public var vinesView: VineFlourishView!
    
    override init(frame: CGRect) {
        super.init(frame: .init(x: frame.minX, y: frame.minY, width: frame.width, height: frame.width / PostcardView.widthHeightRatio))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = frame.width / 375 * 26
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        self.layer.shadowRadius = 5
        
        postcardBackgroundView = UIImageView.init(frame: self.bounds)
        postcardBackgroundView.image = UIImage.init(named: "portcard background")
        postcardBackgroundView.layer.cornerRadius = frame.width / 375 * 26
        postcardBackgroundView.clipsToBounds = true
        postcardBackgroundView.isUserInteractionEnabled = true
        self.addSubview(postcardBackgroundView)
        postcardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        postcardBackgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        postcardBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        postcardBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        postcardBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        layoutStartScene()
        layoutChooseVerseScene()
        layoutOwnWordsScene()
        layoutShareScene()
        
//        vinesView = VineFlourishView.init(frame: .init(x: 0, y: 0, width: 144, height: 51), size: .small)
//        postcardBackgroundView.addSubview(vinesView)
//        vinesView.translatesAutoresizingMaskIntoConstraints = false
//        vinesView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        vinesView.centerYAnchor.constraint(equalTo: postcardBottomView.centerYAnchor).isActive = true
//        vinesView.widthAnchor.constraint(equalToConstant: vinesView.bounds.width).isActive = true
//        vinesView.heightAnchor.constraint(equalToConstant: vinesView.bounds.height).isActive = true
//        defer {
//            vinesView.animate(portion: .left)
//        }
        
        postcardBackgroundView.bringSubviewToFront(postcardBottomView)
        postcardBackgroundView.bringSubviewToFront(cancelButton)
        postcardBackgroundView.bringSubviewToFront(nextButton)
        postcardBackgroundView.bringSubviewToFront(lineView)
//        postcardBackgroundView.bringSubviewToFront(vinesView)
        
        self.layoutIfNeeded()
    }
    
    @objc public func cancelButtonTouchUpInside(_ sender: UIButton) {
        if state == .chooseVerse {
            animateChooseVerse2Start()
        } else if state == .writeWords {
            animateOwnWords2ChooseVerse()
        } else if state == .share {
            animateShare2OwnWords()
        } else if state == .start {
            delegate?.postcardViewDidRequestCancel(self)
        }
    }
    
    @objc public func nextButtonTouchUpInside(_ sender: UIButton) {
        if state == .start {
            animateStart2ChooseVerse()
        } else if state == .chooseVerse {
            animateChooseVerse2OwnWords()
        } else if state == .writeWords {
            textView.resignFirstResponder()
            animateOwnWords2Share()
        } else if state == .share {
            delegate?.postcardView(self, didRequestSaveImageWithVerse: chosenVerse, words: ownWords)
        }
    }
    
    @objc public func chooseVerseButtonTouchUpInside(_ sender: UIButton) {
        delegate?.postcardViewDidRequestChooseVerse(self)
    }
    
    @objc public func shareButtonPressed(_ sender: UIButton) {
        delegate?.postcardView(self, didRequestShareWithMedia: ShareManager.ShareMedia.init(rawValue: sender.tag)!, verse: chosenVerse, words: ownWords)
    }
    
    enum State {
        case idle
        case start
        case chooseVerse
        case writeWords
        case share
        case animating
    }
    
}
