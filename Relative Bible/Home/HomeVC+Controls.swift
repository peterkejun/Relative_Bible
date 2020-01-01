//
//  HomeVC+Controls.swift
//  Bible
//
//  Created by Jun Ke on 8/23/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension HomeViewController {
    
    @objc func infoBarButtonPressed(sender: UIBarButtonItem) {
        let infoVC = InfoViewController.init()
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
}

extension HomeViewController: ParallaxScrollableViewDelegate {
    
    func parallaxScrollableView(_ scrollableView: ParallaxScrollableView, didTapItem item: String) {
        let topicVC = TopicViewController.init()
        topicVC.topic = item
        self.navigationController?.pushViewController(topicVC, animated: true)
    }
    
    func parallaxScrollableViewDidTapSearch(_ scrollableView: ParallaxScrollableView) {
        let topicsSearchVC = TopicsSearchViewController.init()
        self.navigationController?.pushViewController(topicsSearchVC, animated: true)
    }
    
}

