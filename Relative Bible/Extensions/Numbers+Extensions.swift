//
//  Numbers+Extensions.swift
//  Bible
//
//  Created by Jun Ke on 8/15/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension Int {
    func compare(_ other: Int) -> ComparisonResult {
        if self == other {
            return .orderedSame
        } else if self > other {
            return .orderedDescending
        } else {
            return .orderedAscending
        }
    }
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

