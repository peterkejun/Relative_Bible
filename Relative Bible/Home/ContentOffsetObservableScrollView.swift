//
//  ContentOffsetObservableScrollView.swift
//  Bible
//
//  Created by Jun Ke on 8/22/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol ContentOffsetObservableScrollViewDelegate: class {
    func contentOffsetObservableScrollView(_ scrollView: ContentOffsetObservableScrollView, willUpdateContentOffsetTo targetContentOffset: CGPoint)
}

class ContentOffsetObservableScrollView: UIScrollView {
    
    weak var contentOffsetDelegate: ContentOffsetObservableScrollViewDelegate?
    
    override var contentOffset: CGPoint {
        willSet {
            self.contentOffsetDelegate?.contentOffsetObservableScrollView(self, willUpdateContentOffsetTo: newValue)
        }
    }
    
}
