//
//  String+Extensions.swift
//  Bible
//
//  Created by Jun Ke on 8/24/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

extension String {
    var attributedStringFromHTMLString: NSAttributedString {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return NSAttributedString.init(string: "unable to convert \(self)")
        }
        guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
            return NSAttributedString.init(string: "unable to convert \(self)")
        }
        return attributedString
    }
    
    var mutableAttributedStringFromHTMLString: NSMutableAttributedString {
        return NSMutableAttributedString.init(attributedString: self.attributedStringFromHTMLString)
    }
}

