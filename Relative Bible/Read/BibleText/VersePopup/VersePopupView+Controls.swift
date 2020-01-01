//
//  VersePopupView+Controls.swift
//  Bible
//
//  Created by Jun Ke on 8/13/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension VersePopupView {
    
    @objc func copyButtonTouchUpInside(_ sender: UIButton) {
        UIPasteboard.general.string = verse.description
        let alertController = UIAlertController.init(title: "Copied!", message: (verse as VerseTag).description, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.delegate?.alertControllerPresentable.present(alertController, animated: true, completion: nil)
    }
    
    @objc func likeButtonTouchUpInside(_ sender: UIButton) {
        if sender.image(for: .normal) == UIImage.init(named: "like hallow") {
            sender.setImage(UIImage.init(named: "like"), for: .normal)
            self.delegate?.setVerseLiked(true)
        } else {
            sender.setImage(UIImage.init(named: "like hallow"), for: .normal)
            self.delegate?.setVerseLiked(false)
        }
    }
    
    @objc func shareButtonTouchUpInside(_ sender: UIButton) {
        let activityVC = UIActivityViewController.init(activityItems: [verse.description], applicationActivities: nil)
        self.delegate?.alertControllerPresentable.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func cancelButtonTouchUpInside(_ sender: UIButton) {
        self.delegate?.dismissPopupView(self)
    }
    
    @objc func postcardTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    @objc func shareWithFacebook(_ sender: UIButton) {
        
    }
    
    @objc func shareWithInstagram(_ sender: UIButton) {
        
    }
    
    @objc func shareWithMessenger(_ sender: UIButton) {
        
    }
    
    @objc func shareWithTwitter(_ sender: UIButton) {
        
    }
    
    @objc func shareWithWeChat(_ sender: UIButton) {
        
    }
    
    @objc func shareWithQQ(_ sender: UIButton) {
        
    }
    
    @objc func highlightSampleTouchUpInside(_ sender: UIButton) {
        if let color = sender.backgroundColor {
            if color == .white {
                self.delegate?.setHighlightColor(nil)
            } else {
                self.delegate?.setHighlightColor(color)
            }
        }
    }
    
    @objc func scrollIndicatorPanRecognized(_ sender: UIPanGestureRecognizer) {
        let scrollIndicator = sender.view!
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: scrollIndicator).y
            let velocity = sender.translation(in: scrollIndicator).y
            if translation >= 0 && velocity > 100 {
                scrollIndicator.removeGestureRecognizer(sender)
                sender.isEnabled = false
                self.delegate?.dismissPopupView(self)
            }
        default:
            break
        }
    }
    
}

