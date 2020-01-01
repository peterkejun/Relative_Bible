//
//  TestamentSelectionBar.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class TestamentSelector: UIView {
    
    static let standardHeight: CGFloat = 35
    
    private let animationDuration: Double = 0.3
    
    private var oldLabel: UILabel!
    private var newLabel: UILabel!
    private var indicator: UIView!
    private var indicatorLeadingConstraint: NSLayoutConstraint!
    private var indicatorTrailingConstraint: NSLayoutConstraint!
    
    private let selectedFont = UIFont.systemFont(ofSize: 17, weight: .heavy)
    private let unselectedFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    
    private(set) var selected: Int = 0
    
    private var target: AnyObject?
    private var selector: Selector?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        oldLabel = UILabel.init()
        oldLabel.text = "Old Testament"
        oldLabel.font = selectedFont
        oldLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
        oldLabel.sizeToFit()
        self.addSubview(oldLabel)
        oldLabel.translatesAutoresizingMaskIntoConstraints = false
        oldLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        oldLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        newLabel = UILabel.init()
        newLabel.text = "New Testament"
        newLabel.font = unselectedFont
        newLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
        self.addSubview(newLabel)
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.leadingAnchor.constraint(equalTo: oldLabel.trailingAnchor, constant: 15).isActive = true
        newLabel.firstBaselineAnchor.constraint(equalTo: oldLabel.firstBaselineAnchor).isActive = true
        
        indicator = UIView.init()
        indicator.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        indicator.layer.cornerRadius = 1
        self.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.topAnchor.constraint(equalTo: oldLabel.firstBaselineAnchor, constant: 4).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        indicatorLeadingConstraint = indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorLeadingConstraint.isActive = true
        indicatorTrailingConstraint = indicator.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: oldLabel.bounds.width)
        indicatorTrailingConstraint.isActive = true
        
        let line = UIView.init()
        line.backgroundColor = UIColor.init(hex: "C9C9C9")
        self.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.layoutIfNeeded()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if oldLabel.frame.contains(location) && selected == 1 {
            setSelected(0, animated: true)
        } else if newLabel.frame.contains(location) && selected == 0 {
            setSelected(1, animated: true)
        }
    }
    
    func addTarget(_ target: AnyObject, action: Selector) {
        self.target = target
        self.selector = action
    }
    
    func setSelected(_ index: Int, animated: Bool) {
        if index != 0 && index != 1 {
            return
        }
        selected = index
        if animated {
            self.isUserInteractionEnabled = false
            UIView.performWithoutAnimation {
                if index == 0 {
                    self.oldLabel.font = self.selectedFont
                    self.newLabel.font = self.unselectedFont
                } else {
                    self.oldLabel.font = self.unselectedFont
                    self.newLabel.font = self.selectedFont
                }
                self.layoutIfNeeded()
            }
            UIView.animate(withDuration: animationDuration, animations: {
                if index == 0 {
                    self.indicatorLeadingConstraint.constant = self.oldLabel.frame.minX
                    self.indicatorTrailingConstraint.constant = self.oldLabel.frame.maxX
                    self.layoutIfNeeded()
                } else {

                    self.indicatorLeadingConstraint.constant = self.newLabel.frame.minX
                    self.indicatorTrailingConstraint.constant = self.newLabel.frame.maxX
                    self.layoutIfNeeded()
                }
            }) { (_) in
                self.isUserInteractionEnabled = true
            }
        } else {
            if index == 0 {
                oldLabel.font = selectedFont
                newLabel.font = unselectedFont
                indicatorLeadingConstraint.constant = oldLabel.frame.minX
                indicatorTrailingConstraint.constant = oldLabel.frame.maxX
                self.layoutIfNeeded()
            } else {
                oldLabel.font = unselectedFont
                newLabel.font = selectedFont
                indicatorLeadingConstraint.constant = newLabel.frame.minX
                indicatorTrailingConstraint.constant = newLabel.frame.maxX
                self.layoutIfNeeded()
            }
        }
        if let target = target, let selector = selector {
            _ = target.perform(selector)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 12, *) {
            let user_interface_style = self.traitCollection.userInterfaceStyle
            if user_interface_style == .dark {
                self.oldLabel.textColor = .white
                self.newLabel.textColor = .white
                self.indicator.backgroundColor = .white
            } else {
                self.oldLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
                self.newLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
                self.indicator.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
