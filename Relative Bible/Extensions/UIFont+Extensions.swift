//
//  UIFont+Extensions.swift
//  Bible
//
//  Created by Jun Ke on 8/1/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//


import UIKit

extension UIFont {
    
    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
    
}


