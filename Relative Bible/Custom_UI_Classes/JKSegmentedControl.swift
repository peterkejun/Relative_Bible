//
//  JKSegmentedControl.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class JKSegmentedControl: UIView {
    
    static let standardHeight: CGFloat = 32
    
    private let animationDuration: Double = 0.3
    
    private var background: UIView!
    
    private var indicator: UIView!
    private var indicatorCenterXConstraint: NSLayoutConstraint!
    
    private let overlapWidth: CGFloat = 4
    private let itemPadding: CGSize = .init(width: 3, height: 3)
    private let indicatorPadding: CGSize = .init(width: 1, height: 2)
    
    private var items: [String] = []
    
    private(set) var selectedIndex: Int = 0
    
    private var target: AnyObject?
    private var selector: Selector?
    
    init(frame: CGRect, items: [String]) {
        super.init(frame: frame)
        self.items = items
        
        background = UIView.init(frame: frame)
        background.backgroundColor = UIColor.init(hex: "767680").withAlphaComponent(0.24)
        background.layer.cornerRadius = 8.91
        self.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        background.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        background.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let itemCount = items.count
        let applicableWidth = frame.width - 2 * itemPadding.width
        let itemWidth = applicableWidth / CGFloat(itemCount)
        
        for n in 1..<itemCount {
            let seperator = UIView.init()
            seperator.backgroundColor = UIColor.init(hex: "8E8E93")
            seperator.layer.cornerRadius = 0.5
            background.addSubview(seperator)
            seperator.translatesAutoresizingMaskIntoConstraints = false
            seperator.centerXAnchor.constraint(equalTo: background.leadingAnchor, constant: itemPadding.width + CGFloat(n) * itemWidth).isActive = true
            seperator.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
            seperator.widthAnchor.constraint(equalToConstant: 1).isActive = true
            seperator.heightAnchor.constraint(equalTo: background.heightAnchor, multiplier: 0.5).isActive = true
        }
        
        indicator = UIView.init()
        indicator.backgroundColor = UIColor.init(hex: "636366")
        indicator.layer.cornerRadius = 6.93
        background.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicatorCenterXConstraint = indicator.centerXAnchor.constraint(equalTo: background.leadingAnchor, constant: itemPadding.width + CGFloat(2 * selectedIndex + 1) * itemWidth / 2)
        indicatorCenterXConstraint.isActive = true
        indicator.widthAnchor.constraint(equalToConstant: itemWidth + 2 * indicatorPadding.width).isActive = true
        indicator.topAnchor.constraint(equalTo: background.topAnchor, constant: indicatorPadding.height).isActive = true
        indicator.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -indicatorPadding.height).isActive = true
        
        for n in 0..<itemCount {
            let label = UILabel.init()
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label.text = items[n]
            label.textColor = UIColor.white
            label.textAlignment = .center
            background.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: background.leadingAnchor, constant: itemPadding.width + CGFloat(2 * n + 1) * itemWidth / 2).isActive = true
            label.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        }
        
    }
    
    func addTarget(_ target: AnyObject, action: Selector) {
        self.target = target
        self.selector = action
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let itemCount = items.count
        let applicableWidth = frame.width - 2 * itemPadding.width
        let itemWidth = applicableWidth / CGFloat(itemCount)
        let location = touch.location(in: self)
        var index: Int = -1
        if self.bounds.contains(location) {
            for n in 1...itemCount {
                if location.x < itemPadding.width + CGFloat(n) * itemWidth {
                    index = n - 1
                    break
                }
            }
        }
        if index != -1 && index != selectedIndex {
            setSelectedIndex(index, animated: true)
        }
    }
    
    func setSelectedIndex(_ index: Int, animated: Bool) {
        let itemCount = items.count
        let applicableWidth = frame.width - 2 * itemPadding.width
        let itemWidth = applicableWidth / CGFloat(itemCount)
        selectedIndex = index
        if animated {
            self.isUserInteractionEnabled = false
            UIView.animate(withDuration: animationDuration, animations: {
                self.indicatorCenterXConstraint.constant = self.itemPadding.width + CGFloat(2 * index + 1) * itemWidth / 2
                self.layoutIfNeeded()
            }) { (_) in
                self.isUserInteractionEnabled = true
            }
        } else {
            self.indicatorCenterXConstraint.constant = self.itemPadding.width + CGFloat(2 * index + 1) * itemWidth / 2
            self.layoutIfNeeded()
        }
        if let target = target, let selector = selector {
            _ = target.perform(selector)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
