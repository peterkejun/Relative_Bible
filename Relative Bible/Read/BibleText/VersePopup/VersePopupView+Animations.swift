//
//  VersePopupView+Animations.swift
//  Bible
//
//  Created by Jun Ke on 8/15/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension VersePopupView {
    
    public func jiggle() {
        let rotateDegree: CGFloat = 1.0
        let randomInt = CGFloat(arc4random_uniform(500))
        let r = randomInt / 500 + 0.5
        
        let leftWobble = CGAffineTransform.init(rotationAngle: (-rotateDegree - r).degreesToRadians)
        let rightWobble = CGAffineTransform.init(rotationAngle: (rotateDegree + r).degreesToRadians)
        
        self.postcardImageView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        
        let duration: Double = 1.3
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.allowUserInteraction, .repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0 / duration, relativeDuration: 0.1 / duration, animations: {
                self.postcardImageView.transform = leftWobble
            })
            UIView.addKeyframe(withRelativeStartTime: 0.1 / duration, relativeDuration: 0.2 / duration, animations: {
                self.postcardImageView.transform = rightWobble
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3 / duration, relativeDuration: 0.1 / duration, animations: {
                self.postcardImageView.transform = .identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4 / duration, relativeDuration: 0.1 / duration, animations: {
                self.postcardImageView.transform = leftWobble
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5 / duration, relativeDuration: 0.2 / duration, animations: {
                self.postcardImageView.transform = rightWobble
            })
            UIView.addKeyframe(withRelativeStartTime: 0.7 / duration, relativeDuration: 0.2 / duration, animations: {
                self.postcardImageView.transform = .identity
            })
        }, completion: nil)
    }
    
    public func stopJiggle() {
        self.postcardImageView.layer.removeAllAnimations()
        self.postcardImageView.transform = CGAffineTransform.identity
    }
    
}

