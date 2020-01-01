//
//  HomeVC+Layout.swift
//  Bible
//
//  Created by Jun Ke on 8/23/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension HomeViewController {
    
    func layout() {
        self.scrollView = UIScrollView.init()
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let topics = BibleData.topics.shuffled()
        var items: [UILabel] = []
        for topic in topics {
            let label = UILabel.init()
            label.text = topic
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            if #available(iOS 13.0, *) {
                label.textColor = UIColor.label.withAlphaComponent(0.7)
            } else {
                label.textColor = UIColor.black.withAlphaComponent(0.7)
            }
            items.append(label)
        }
        self.topicsScrollableView = ParallaxScrollableView.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: self.topicsScrollableViewHeight), items: items)
        self.topicsScrollableView.backgroundColor = UIColor.clear
        self.topicsScrollableView.delegate = self
        self.scrollView.addSubview(self.topicsScrollableView)
        self.topicsScrollableView.translatesAutoresizingMaskIntoConstraints = false
        self.topicsScrollableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.topicsScrollableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.topicsScrollableView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.topicsScrollableView.heightAnchor.constraint(equalToConstant: self.topicsScrollableView.bounds.height).isActive = true
        
        let seperator1 = self.seperator
        self.scrollView.addSubview(seperator1)
        seperator1.translatesAutoresizingMaskIntoConstraints = false
        seperator1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        seperator1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        seperator1.topAnchor.constraint(equalTo: self.topicsScrollableView.bottomAnchor, constant: 5).isActive = true
        seperator1.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.layoutVerseOfTheDay()
        
        let seperator2 = self.seperator
        self.scrollView.addSubview(seperator2)
        seperator2.translatesAutoresizingMaskIntoConstraints = false
        seperator2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        seperator2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        seperator2.topAnchor.constraint(equalTo: self.votdView.bottomAnchor, constant: 5).isActive = true
        seperator2.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.layoutTodaysDevotional()
        
        self.scrollView.layoutIfNeeded()
        self.scrollView.contentSize = CGSize.init(width: self.scrollView.bounds.width, height: self.tdView.frame.maxY + 20)
    }
    
    var placeholderHeight: CGFloat {
        return 150
    }
    
    var verticalLine: UIView {
        let v = UIView.init()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return v
    }
    
    var seperator: UIView {
        let v = UIView.init()
        v.backgroundColor = UIColor.init(hex: "D6D6D6")
        return v
    }
    
}

