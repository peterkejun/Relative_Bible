//
//  CGRect+Extensions.swift
//  Bible
//
//  Created by Peter Ke on 2019-10-11.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    var diagonal_length: CGFloat {
        return sqrt(self.width * self.width + self.height * self.height)
    }
    
}
