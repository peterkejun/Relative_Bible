//
//  PostcardView+TextView.swift
//  Holy Bible
//
//  Created by Jun Ke on 7/20/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension PostcardView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "" {
            if nextButton.title(for: .normal) != "Next" {
                UIView.performWithoutAnimation {
                    self.nextButton.setTitle("Next", for: .normal)
                }
            }
        } else {
            UIView.performWithoutAnimation {
                self.nextButton.setTitle("Skip", for: .normal)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = UIColor.lightGray
            self.ownWords = nil
        } else {
            self.ownWords = textView.text
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    var textViewPlaceHolder: String {
        return """
        How about...
        - Sharing your understanding of the verse,
        - A greeting, congratulations, a comfort, etc.,
        - Asking if you could pray for him...
        """
    }
    
    var textViewPlaceHolderAttributedString: NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 8
        return NSAttributedString.init(string: textViewPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.paragraphStyle : paragraphStyle])
    }
    
}

