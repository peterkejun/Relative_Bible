//
//  ParallaxScrollableView.swift
//  Bible
//
//  Created by Jun Ke on 8/22/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

fileprivate typealias ItemRange = (startInclusive: Int, endInclusive: Int)

protocol ParallaxScrollableViewDelegate: class {
    func parallaxScrollableView(_ scrollableView: ParallaxScrollableView, didTapItem item: String)
    func parallaxScrollableViewDidTapSearch(_ scrollableView: ParallaxScrollableView)
}

class ParallaxScrollableView: UIView {
    
    weak var delegate: ParallaxScrollableViewDelegate?
    
    var autoScroll: Bool = false {
        didSet {
            if self.autoScroll {
                self.autoScrollTimer?.invalidate()
                var maxContentSize: CGSize = .zero
                var maxSizeScrollView: UIScrollView = self.primaryScrollView
                for scrollView in [self.secondaryScrollView!, self.tertiaryScrollView!] {
                    if scrollView.contentSize.width >= maxContentSize.width {
                        maxSizeScrollView = scrollView
                        maxContentSize = scrollView.contentSize
                    }
                }
                let interval: TimeInterval = 0.03
                let offset: CGFloat = 0.9
                let endingBound: CGFloat = maxContentSize.width - maxSizeScrollView.bounds.width
                self.autoScrollTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { (timer) in
                    if maxSizeScrollView.contentOffset.x + offset <= endingBound {
                        self.primaryScrollView.bounds = CGRect.init(x: self.primaryScrollView.bounds.minX + offset, y: self.primaryScrollView.bounds.minY, width: self.primaryScrollView.bounds.width, height: self.primaryScrollView.bounds.height)
                        self.secondaryScrollView.bounds = CGRect.init(x: self.secondaryScrollView.bounds.minX + offset / 2, y: self.secondaryScrollView.bounds.minY, width: self.secondaryScrollView.bounds.width, height: self.secondaryScrollView.bounds.height)
                        self.tertiaryScrollView.bounds = CGRect.init(x: self.tertiaryScrollView.bounds.minX + offset / 3, y: self.tertiaryScrollView.bounds.minY, width: self.tertiaryScrollView.bounds.width, height: self.tertiaryScrollView.bounds.height)
                        self.contextView.alpha = self.contextAlpha(contentOffset: self.primaryScrollView.contentOffset)
                    }
                })
            } else {
                self.autoScrollTimer?.invalidate()
                self.autoScrollTimer = nil
            }
        }
    }
    
    var contextView: UIView!
    
    private(set) var autoScrollTimer: Timer?
    
    private(set) var delayAutoScrollTimer: Timer?
    
    private(set) var items: [UILabel] = [] {
        didSet {
            let count = self.items.count
            primaryRange = (0, count / 2 - 1)
            secondaryRange = (count / 2, count * 5 / 6 - 1)
            tertiaryRange = (count * 5 / 6, count - 1)
        }
    }
    fileprivate var primaryRange: ItemRange = (-1, -1)
    fileprivate var secondaryRange: ItemRange = (-1, -1)
    fileprivate var tertiaryRange: ItemRange = (-1, -1)
    var tertiaryScrollView: UIScrollView!
    var secondaryScrollView: UIScrollView!
    var primaryScrollView: ContentOffsetObservableScrollView!
    
    var contextLabel: UILabel!
    var searchBar: UISearchBar!
    
    init(frame: CGRect, items: [UILabel]) {
        super.init(frame: frame)
        self.items = items
        let count = self.items.count
        primaryRange = (0, count / 2 - 1)
        secondaryRange = (count / 2, count * 5 / 6 - 1)
        tertiaryRange = (count * 5 / 6, count - 1)
        self.backgroundColor = UIColor.white
        
        self.contextView = UIView.init(frame: frame)
        self.contextView.backgroundColor = UIColor.clear
        self.addSubview(self.contextView)
        self.contextView.translatesAutoresizingMaskIntoConstraints = false
        self.contextView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.contextView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.contextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.contextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.contextLabel = UILabel.init()
        self.contextLabel.text = "What does the bible\nsay about..."
        self.contextLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        if #available(iOS 13.0, *) {
            self.contextLabel.textColor = UIColor.label
        } else {
            self.contextLabel.textColor = UIColor.black.withAlphaComponent(0.7)
        }
        self.contextLabel.textAlignment = .center
        self.contextLabel.numberOfLines = 0
        self.contextView.addSubview(self.contextLabel)
        self.contextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contextLabel.centerXAnchor.constraint(equalTo: self.contextView.centerXAnchor).isActive = true
        self.contextLabel.bottomAnchor.constraint(equalTo: self.contextView.centerYAnchor, constant: -7.5).isActive = true
        
        self.searchBar = UISearchBar.init()
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.tintColor = UIColor.white
        self.searchBar.barTintColor = UIColor.white
        self.searchBar.layer.cornerRadius = 12
        self.searchBar.placeholder = "Search for a topic"
        self.searchBar.isUserInteractionEnabled = false
        self.contextView.addSubview(self.searchBar)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.centerXAnchor.constraint(equalTo: self.contextView.centerXAnchor).isActive = true
        self.searchBar.widthAnchor.constraint(equalToConstant: 292).isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: 51).isActive = true
        self.searchBar.topAnchor.constraint(equalTo: self.contextView.centerYAnchor, constant: 7.5).isActive = true
        
        self.tertiaryScrollView = UIScrollView.init(frame: frame)
        self.tertiaryScrollView.backgroundColor = UIColor.clear
        self.addSubview(self.tertiaryScrollView)
        self.tertiaryScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.tertiaryScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.tertiaryScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.tertiaryScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.tertiaryScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tertiaryScrollView.isUserInteractionEnabled = false
        
        self.secondaryScrollView = UIScrollView.init(frame: frame)
        self.secondaryScrollView.backgroundColor = UIColor.clear
        self.addSubview(self.secondaryScrollView)
        self.secondaryScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.secondaryScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.secondaryScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.secondaryScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.secondaryScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.secondaryScrollView.isUserInteractionEnabled = false
        
        self.primaryScrollView = ContentOffsetObservableScrollView.init(frame: frame)
        self.primaryScrollView.backgroundColor = UIColor.clear
        self.primaryScrollView.delegate = self
        self.primaryScrollView.contentOffsetDelegate = self
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        self.primaryScrollView.addGestureRecognizer(tapGestureRecognizer)
        self.addSubview(self.primaryScrollView)
        self.primaryScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.primaryScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.primaryScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.primaryScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.primaryScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let alphas: [CGFloat] = [1, 0.6, 0.3]
        let ranges = [self.primaryRange, self.secondaryRange, self.tertiaryRange]
        for (s, scrollView) in [self.primaryScrollView!, self.secondaryScrollView!, self.tertiaryScrollView!].enumerated() {
            let range = ranges[s]
            let items = self.items[range.startInclusive...range.endInclusive]
            var previousItem: UILabel? = nil
            let verticalPadding: CGFloat = 30
            for item in items {
                item.alpha = alphas[s]
                scrollView.addSubview(item)
                item.translatesAutoresizingMaskIntoConstraints = false
                if let pi = previousItem {
                    item.leadingAnchor.constraint(equalTo: pi.trailingAnchor, constant: self.columnPadding).isActive = true
                } else {
                    item.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(s) * self.levelPadding + self.bounds.width).isActive = true
                }
                let yOffset = verticalPadding + (scrollView.bounds.height - 2 * verticalPadding) * self.randomPercent
                item.centerYAnchor.constraint(equalTo: scrollView.topAnchor, constant: yOffset).isActive = true
                previousItem = item
            }
            scrollView.layoutIfNeeded()
            scrollView.contentSize = .init(width: previousItem!.frame.maxX + self.columnPadding, height: scrollView.bounds.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tertiarySpeed: CGFloat {
        return 2
    }
    
    var secondarySpeed: CGFloat {
        return self.tertiarySpeed * 2
    }
    
    var primarySpeed: CGFloat {
        return self.tertiarySpeed * 3
    }
    
    var randomPercent: CGFloat {
        return CGFloat.random(in: 0...1)
    }
    
    var columnPadding: CGFloat {
        return 100
    }
    
    var levelPadding: CGFloat {
        return 30
    }
    
    var delayAutoScrollInterval: TimeInterval {
        return 1.0
    }
    
    func contextAlpha(contentOffset: CGPoint) -> CGFloat {
        if contentOffset.x <= 100 {
            return 1 - contentOffset.x / 100
        } else {
            return 0
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let ranges = [self.primaryRange, self.secondaryRange, self.tertiaryRange]
        var topic: String? = nil
        for (s, scrollView) in [self.primaryScrollView!, self.secondaryScrollView!, self.tertiaryScrollView!].enumerated() {
            let translatedLocation = CGPoint.init(x: location.x + scrollView.contentOffset.x, y: location.y)
            for item in self.items[ranges[s].startInclusive...ranges[s].endInclusive] {
                if item.frame.contains(translatedLocation) {
                    topic = item.text
                    break
                }
            }
            if topic != nil {
                break
            }
        }
        if topic != nil {
            self.delegate?.parallaxScrollableView(self, didTapItem: topic!)
        } else {
            if self.searchBar.frame.contains(location) && self.contextView.alpha != 0 {
                self.delegate?.parallaxScrollableViewDidTapSearch(self)
            }
        }
    }
    
}

extension ParallaxScrollableView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delayAutoScrollTimer?.invalidate()
        self.delayAutoScrollTimer = nil
        self.autoScroll = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            self.delayAutoScrollTimer = Timer.scheduledTimer(withTimeInterval: self.delayAutoScrollInterval, repeats: false, block: { (_) in
                self.autoScroll = true
                self.delayAutoScrollTimer?.invalidate()
                self.delayAutoScrollTimer = nil
            })
        } else {
            self.autoScroll = true
        }
    }
    
}

extension ParallaxScrollableView: ContentOffsetObservableScrollViewDelegate {
    
    func contentOffsetObservableScrollView(_ scrollView: ContentOffsetObservableScrollView, willUpdateContentOffsetTo targetContentOffset: CGPoint) {
        let offset = targetContentOffset.x - scrollView.contentOffset.x
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.secondaryScrollView.contentOffset.x += offset / 2
        self.tertiaryScrollView.contentOffset.x += offset / 3
        self.contextView.alpha = self.contextAlpha(contentOffset: targetContentOffset)
        CATransaction.commit()
    }
    
}


