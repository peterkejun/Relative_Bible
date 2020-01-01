//
//  HomeVC+ScrollView.swift
//  Bible
//
//  Created by Jun Ke on 8/24/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= self.topicsScrollableViewHeight {
            self.topicsScrollableView.autoScroll = false
        } else {
            self.topicsScrollableView.autoScroll = true
        }
    }
    
}

