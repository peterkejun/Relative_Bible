//
//  PostcardView+Animations.swift
//  Holy Bible
//
//  Created by Jun Ke on 7/20/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension PostcardView {
    
    public func jiggle() {
        let rotateDegree: CGFloat = 1.0
        let randomInt = CGFloat(arc4random_uniform(500))
        let r = randomInt / 500 + 0.5
        
        let leftWobble = CGAffineTransform.init(rotationAngle: (-rotateDegree - r).degreesToRadians)
        let rightWobble = CGAffineTransform.init(rotationAngle: (rotateDegree + r).degreesToRadians)
        
        self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        
        let duration: Double = 1.3
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.allowUserInteraction, .repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0 / duration, relativeDuration: 0.1 / duration, animations: {
                self.transform = leftWobble
            })
            UIView.addKeyframe(withRelativeStartTime: 0.1 / duration, relativeDuration: 0.2 / duration, animations: {
                self.transform = rightWobble
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3 / duration, relativeDuration: 0.1 / duration, animations: {
                self.transform = .identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4 / duration, relativeDuration: 0.1 / duration, animations: {
                self.transform = leftWobble
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5 / duration, relativeDuration: 0.2 / duration, animations: {
                self.transform = rightWobble
            })
            UIView.addKeyframe(withRelativeStartTime: 0.7 / duration, relativeDuration: 0.2 / duration, animations: {
                self.transform = .identity
            })
        }, completion: nil)
    }
    
    public func stopJiggle() {
        self.layer.removeAllAnimations()
        self.transform = CGAffineTransform.identity
    }
    
    public func beginEditing() {
        if state != .idle {
            return
        }
        self.isUserInteractionEnabled = false
        self.state = .animating
        UIView.performWithoutAnimation {
            self.nextButton.setTitle("Start", for: .normal)
            self.cancelButton.setTitle("Cancel", for: .normal)
            self.cancelButton.setTitleColor(UIColor.init(hex: "D0021B"), for: .normal)
        }
        UIView.animate(withDuration: 0.1) {
            self.nextButton.alpha = 1
            self.cancelButton.alpha = 1
            self.itsEasyLabel.alpha = 1
        }
        UIView.animate(withDuration: 0.1, delay: 0.05, options: [], animations: {
            self.firstStepLabel.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {
            self.secondStepLabel.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.1, delay: 0.15, options: [], animations: {
            self.thirdStepLabel.alpha = 1
        }) { (_) in
            self.isUserInteractionEnabled = true
            self.state = .start
        }
        shareButtonsPadding = 30
        shareButtonCellWidth = (self.bounds.width - 2 * shareButtonsPadding) / 4
        titleLabelLeadingConstraint.constant = 20 + self.bounds.width
        mark16LabelLeadingConstraint.constant = 34 + self.bounds.width
        mark16LabelTrailingConstraint.constant = -34 + self.bounds.width
        mark16SourceLabelTrailingConstraint.constant = -34 + self.bounds.width
        textViewContainerTopConstraint.constant = 10 + self.bounds.height
        textViewContainerBottomConstraint.constant = -5 + self.bounds.height
        facebookButtonCenterXConstraint.constant = shareButtonsPadding + shareButtonCellWidth / 2 + self.bounds.width
        instagramButtonCenterXConstraint.constant = shareButtonsPadding + shareButtonCellWidth * 3 / 2 + self.bounds.width
        messengerButtonCenterXConstraint.constant = shareButtonsPadding + shareButtonCellWidth * 5 / 2 + self.bounds.width
        whatsAppButtonCenterXConstraint.constant = shareButtonsPadding + shareButtonCellWidth * 7 / 2 + self.bounds.width
        self.layoutIfNeeded()
    }

    public func stopEditing() {
        if self.state == .idle {
            return
        }
        self.isUserInteractionEnabled = false
        self.state = .animating
        UIView.animate(withDuration: 0.4, animations: {
            self.lineView.backgroundColor = UIColor.clear
            self.coverImageViewLeadingConstraint.constant = 0
            self.coverImageViewTrailingConstraint.constant = 0
            self.coverImageViewTopConstraint.constant = 0
            self.nextButton.alpha = 0
            self.cancelButton.alpha = 0
            self.itsEasyLabel.alpha = 0
            self.firstStepLabel.alpha = 0
            self.secondStepLabel.alpha = 0
            self.thirdStepLabel.alpha = 0
            self.layoutIfNeeded()
        }) { (_) in
            self.isUserInteractionEnabled = true
            self.state = .idle
        }
        titleLabelLeadingConstraint.constant = 20 + self.bounds.width
        mark16LabelLeadingConstraint.constant = 34 + self.bounds.width
        mark16LabelTrailingConstraint.constant = -34 + self.bounds.width
        mark16SourceLabelTrailingConstraint.constant = -34 + self.bounds.width
        textViewContainerTopConstraint.constant = 10 + self.bounds.height
        textViewContainerBottomConstraint.constant = -5 + self.bounds.height
        facebookButtonCenterXConstraint.constant = shareButtonsPadding + shareButtonCellWidth / 2 + self.bounds.width
        instagramButtonCenterXConstraint.constant = shareButtonsPadding + shareButtonCellWidth * 3 / 2 + self.bounds.width
        messengerButtonCenterXConstraint.constant = shareButtonsPadding + shareButtonCellWidth * 5 / 2 + self.bounds.width
        whatsAppButtonCenterXConstraint.constant = shareButtonsPadding + shareButtonCellWidth * 7 / 2 + self.bounds.width
        self.layoutIfNeeded()
    }
    
    public func animateStart2ChooseVerse() {
        self.isUserInteractionEnabled = false
        self.state = .animating
        UIView.performWithoutAnimation {
            self.nextButton.setTitle(self.chosenVerse == nil ? "Skip" : "Next", for: .normal)
            self.cancelButton.setTitle("Previous", for: .normal)
            self.layoutIfNeeded()
        }
        self.cancelButton.setTitleColor(UIColor.init(hex: "4A4A4A"), for: .normal)
        self.titleLabel.text = chooseVerseTitle
        //        vinesView.animate(portion: .rightBottom)
        UIView.animate(withDuration: 0.4) {
            self.coverImageViewLeadingConstraint.constant = self.lineView.frame.minX
            self.coverImageViewTrailingConstraint.constant = -self.lineView.frame.minX
            self.coverImageViewTopConstraint.constant = self.lineView.frame.maxY
            self.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.1) {
            self.itsEasyLabel.alpha = 0
            self.firstStepLabel.alpha = 0
            self.secondStepLabel.alpha = 0
            self.thirdStepLabel.alpha = 0
            self.lineView.backgroundColor = UIColor.palette[3]
        }
        UIView.animate(withDuration: 0.5, delay: 0.05, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.titleLabel.alpha = 1
            self.titleLabelLeadingConstraint.constant = 20
            self.layoutIfNeeded()
        })
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.mark16Label.alpha = 1
            self.mark16LabelLeadingConstraint.constant = 34
            self.mark16LabelTrailingConstraint.constant = -34
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.15, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.mark16SourceLabel.alpha = 1
            self.mark16SourceLabelTrailingConstraint.constant = -34
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.chooseButton.alpha = 1
            self.chooseButtonCenterXConstraint.constant = 0
            self.layoutIfNeeded()
        }) { (_) in
            self.isUserInteractionEnabled = true
            self.state = .chooseVerse
        }
    }
    
    public func animateChooseVerse2Start() {
        self.isUserInteractionEnabled = false
        self.state = .animating
        UIView.performWithoutAnimation {
            self.nextButton.setTitle("Start", for: .normal)
            self.cancelButton.setTitle("Cancel", for: .normal)
            self.layoutIfNeeded()
        }
        self.cancelButton.setTitleColor(UIColor.init(hex: "D0021B"), for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.alpha = 0
            self.titleLabelLeadingConstraint.constant = 20 + self.bounds.width
            self.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.5, delay: 0.05, options: [], animations: {
            self.mark16Label.alpha = 0
            self.mark16LabelLeadingConstraint.constant = 34 + self.bounds.width
            self.mark16LabelTrailingConstraint.constant = -34 + self.bounds.width
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
            self.mark16SourceLabel.alpha = 0
            self.mark16SourceLabelTrailingConstraint.constant = -34 + self.bounds.width
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.15, options: [], animations: {
            self.chooseButton.alpha = 0
            self.chooseButtonCenterXConstraint.constant = self.bounds.width
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.1, delay: 0.5, options: [], animations: {
            self.itsEasyLabel.alpha = 1
            self.firstStepLabel.alpha = 1
            self.secondStepLabel.alpha = 1
            self.thirdStepLabel.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
            self.lineView.backgroundColor = UIColor.clear
            self.coverImageViewLeadingConstraint.constant = 0
            self.coverImageViewTrailingConstraint.constant = 0
            self.coverImageViewTopConstraint.constant = 0
            self.layoutIfNeeded()
        }) { (_) in
            self.isUserInteractionEnabled = true
            self.state = .start
        }
    }
    
    public func animateChooseVerse2OwnWords() {
        self.isUserInteractionEnabled = false
        self.state = .animating
        UIView.performWithoutAnimation {
            self.nextButton.setTitle(ownWords == nil ? "Skip" : "Next", for: .normal)
            self.layoutIfNeeded()
        }
        //        vinesView.animate(portion: .rightTop)
        self.titleLabel.text = ownWordsTitle
        UIView.animate(withDuration: 0.1) {
            self.lineView.backgroundColor = UIColor.palette[2]
        }
        UIView.animate(withDuration: 0.3, delay: 0.05, options: [], animations: {
            self.mark16Label.alpha = 0
            self.mark16LabelLeadingConstraint.constant = 34 - self.bounds.width
            self.mark16LabelTrailingConstraint.constant = -34 - self.bounds.width
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
            self.mark16SourceLabel.alpha = 0
            self.mark16SourceLabelTrailingConstraint.constant = -34 - self.bounds.width
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.15, options: [], animations: {
            self.chooseButton.alpha = 0
            self.chooseButtonCenterXConstraint.constant -= self.bounds.width
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.15, options: [], animations: {
            self.textViewContainerTopConstraint.constant = 10
            self.textViewContainerBottomConstraint.constant = -5
            self.layoutIfNeeded()
        }) { (_) in
            self.isUserInteractionEnabled = true
            self.state = .writeWords
        }
    }
    
    public func animateOwnWords2ChooseVerse() {
        self.isUserInteractionEnabled = false
        self.state = .animating
        UIView.performWithoutAnimation {
            self.nextButton.setTitle(self.chosenVerse == nil ? "Skip" : "Next", for: .normal)
        }
        self.titleLabel.text = chooseVerseTitle
        UIView.animate(withDuration: 0.5, delay: 0.05, options: [], animations: {
            self.textViewContainerTopConstraint.constant = 10 + self.bounds.height
            self.textViewContainerBottomConstraint.constant = -5 + self.bounds.height
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.mark16Label.alpha = 1
            self.mark16LabelLeadingConstraint.constant = 34
            self.mark16LabelTrailingConstraint.constant = -34
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.15, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.mark16SourceLabel.alpha = 1
            self.mark16SourceLabelTrailingConstraint.constant = -34
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
            self.lineView.backgroundColor = UIColor.palette[3]
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.chooseButton.alpha = 1
            self.chooseButtonCenterXConstraint.constant = 0
            self.layoutIfNeeded()
        }) { (_) in
            self.isUserInteractionEnabled = true
            self.state = .chooseVerse
        }
    }
    
    public func animateOwnWords2Share() {
        self.isUserInteractionEnabled = false
        self.state = .animating
        UIView.performWithoutAnimation {
            self.nextButton.setTitle("Save Image", for: .normal)
            self.layoutIfNeeded()
        }
        self.titleLabel.text = shareTitle
        UIView.animate(withDuration: 0.1) {
            self.lineView.backgroundColor = UIColor.palette[1]
        }
        UIView.animate(withDuration: 0.3) {
            self.textViewContainerTopConstraint.constant = 10 + self.bounds.height
            self.textViewContainerBottomConstraint.constant = -5 + self.bounds.height
            self.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.facebookButtonCenterXConstraint.constant = self.shareButtonsPadding + self.shareButtonCellWidth / 2
            self.facebookButton.alpha = 1
            self.twitterButton.alpha = 1
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.15, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.instagramButtonCenterXConstraint.constant = self.shareButtonsPadding + self.shareButtonCellWidth * 3 / 2
            self.instagramButton.alpha = 1
            self.wechatButton.alpha = 1
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.messengerButtonCenterXConstraint.constant = self.shareButtonsPadding + self.shareButtonCellWidth * 5 / 2
            self.messengerButton.alpha = 1
            self.qqButton.alpha = 1
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.whatsAppButtonCenterXConstraint.constant = self.shareButtonsPadding + self.shareButtonCellWidth * 7 / 2
            self.whatsAppButton.alpha = 1
            self.weiboButton.alpha = 1
            self.layoutIfNeeded()
        }) { (_) in
            self.isUserInteractionEnabled = true
            self.state = .share
        }
    }
    
    public func animateShare2OwnWords() {
        self.isUserInteractionEnabled = false
        self.state = .animating
        UIView.performWithoutAnimation {
            self.nextButton.setTitle(ownWords == nil ? "Skip" : "Next", for: .normal)
            self.layoutIfNeeded()
        }
        self.titleLabel.text = ownWordsTitle
        UIView.animate(withDuration: 0.1) {
            self.lineView.backgroundColor = UIColor.palette[2]
        }
        UIView.animate(withDuration: 0.5, delay: 0.05, options: [], animations: {
            self.whatsAppButtonCenterXConstraint.constant = self.shareButtonsPadding + self.shareButtonCellWidth * 7 / 2 + self.bounds.width
            self.whatsAppButton.alpha = 0
            self.weiboButton.alpha = 0
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
            self.messengerButtonCenterXConstraint.constant = self.shareButtonsPadding + self.shareButtonCellWidth * 5 / 2 + self.bounds.width
            self.messengerButton.alpha = 0
            self.qqButton.alpha = 0
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.15, options: [], animations: {
            self.instagramButtonCenterXConstraint.constant = self.shareButtonsPadding + self.shareButtonCellWidth * 3 / 2 + self.bounds.width
            self.instagramButton.alpha = 0
            self.wechatButton.alpha = 0
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [], animations: {
            self.facebookButtonCenterXConstraint.constant = self.shareButtonsPadding + self.shareButtonCellWidth * 3 / 2 + self.bounds.width
            self.facebookButton.alpha = 0
            self.twitterButton.alpha = 0
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.25, options: [], animations: {
            self.textViewContainerTopConstraint.constant = 10
            self.textViewContainerBottomConstraint.constant = -5
            self.layoutIfNeeded()
        }) { (_) in
            self.isUserInteractionEnabled = true
            self.state = .writeWords
        }
    }
    
}



