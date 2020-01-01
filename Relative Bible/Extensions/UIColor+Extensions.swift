//
//  UIColor+Extensions.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let palette: [UIColor] = [
        UIColor.init(hex: "37487B"),
        UIColor.init(hex: "61557A"),
        UIColor.init(hex: "AF6479"),
        UIColor.init(hex: "EF6F7F")
    ]
    
    static var barTintColor: UIColor {
        return UIColor.init(hex: "F9F9F9")
    }
    
    static var lightGrayBackgroundColor: UIColor {
        return UIColor.init(hex: "EEEEF3")
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    var hexString: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return NSString(format:"%06x", rgb).uppercased
    }
    
}


