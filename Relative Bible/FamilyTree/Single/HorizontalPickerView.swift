//
//  HorizontalPickerView.swift
//  Bible
//
//  Created by Peter Ke on 2019-10-11.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol HorizontalPickerViewDelegate: class {
    func horizontalPickerView(_ horizontalPickerView: HorizontalPickerView, didSelectItemAtIndex index: Int)
}

class HorizontalPickerView: UIView {

    var scroll_view: UIScrollView!
    
    var items: [String] = []
    
    weak var delegate: HorizontalPickerViewDelegate?
    
    //layout
    var labels: [UILabel] = []
    var trigger_left: [CGFloat] = []
    var trigger_right: [CGFloat] = []
    var x_stretches: [CGFloat] = []
    var x_shifts: [CGFloat] = []
    let max_scale: CGFloat = 1.2
    var indicator_layer: CAShapeLayer?
    var left_gradient_layer: CAGradientLayer?
    var right_gradient_layer: CAGradientLayer?
    
    var feedback_generator: UISelectionFeedbackGenerator?
    
    //selection
    var presumed_selection_index: Int = -1
    var current_selection_index: Int = -1
    
    init(frame: CGRect, items: [String]) {
        super.init(frame: frame)
        
        var context_color = UIColor.init(red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0)
        var focus_color = UIColor.white
        if #available(iOS 13, *) {
            context_color = UIColor.systemGray5
            focus_color = UIColor.label
        }
        
        self.backgroundColor = context_color
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
        if #available(iOS 13, *) {
            self.layer.borderColor = UIColor.secondaryLabel.cgColor
        } else {
            self.layer.borderColor = UIColor.lightGray.cgColor
        }
        self.clipsToBounds = true
        
        self.scroll_view = UIScrollView.init(frame: self.frame)
        self.scroll_view.delegate = self
        self.scroll_view.isScrollEnabled = true
        self.scroll_view.isUserInteractionEnabled = true
        self.scroll_view.showsHorizontalScrollIndicator = false
        self.scroll_view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.scrollviewTapped(_:))))
        self.addSubview(self.scroll_view)
        self.scroll_view.translatesAutoresizingMaskIntoConstraints = false
        self.scroll_view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scroll_view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scroll_view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scroll_view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //layout items
        self.reset(items: items)
        
        //feedback
        self.feedback_generator = UISelectionFeedbackGenerator.init()
        
        //indicator
        self.indicator_layer = CAShapeLayer.init()
        self.indicator_layer?.bounds = .init(x: 0, y: 0, width: 5, height: 5)
        self.indicator_layer?.path = CGPath.init(ellipseIn: indicator_layer!.bounds, transform: nil)
        self.indicator_layer?.fillColor = focus_color.cgColor
        self.indicator_layer?.position = .init(x: self.frame.midX, y: self.frame.maxY - 8)
        self.layer.addSublayer(self.indicator_layer!)
        
        //gradient sides
        self.left_gradient_layer = CAGradientLayer.init()
        self.left_gradient_layer?.startPoint = .init(x: 0, y: 0.5)
        self.left_gradient_layer?.endPoint = .init(x: 1, y: 0.5)
        self.left_gradient_layer?.colors = [context_color.cgColor, context_color.withAlphaComponent(0).cgColor]
        self.left_gradient_layer?.bounds = .init(x: 0, y: 0, width: self.frame.width * 111 / 358, height: self.frame.height)
        self.left_gradient_layer?.anchorPoint = .init(x: 0, y: 0)
        self.left_gradient_layer?.position = .zero
        self.layer.addSublayer(self.left_gradient_layer!)
        self.right_gradient_layer = CAGradientLayer.init()
        self.right_gradient_layer?.startPoint = .init(x: 0, y: 0.5)
        self.right_gradient_layer?.endPoint = .init(x: 1, y: 0.5)
        self.right_gradient_layer?.colors = [context_color.withAlphaComponent(0).cgColor, context_color.cgColor]
        self.right_gradient_layer?.bounds = .init(x: 0, y: 0, width: self.frame.width * 111 / 358, height: self.frame.height)
        self.right_gradient_layer?.anchorPoint = .init(x: 1, y: 0)
        self.right_gradient_layer?.position = .init(x: self.bounds.maxX, y: 0)
        self.layer.addSublayer(self.right_gradient_layer!)
    }
    
    func reset(items: [String]) {
        //remove previous labels and cache
        self.items = items
        for label in self.labels {
            label.removeFromSuperview()
        }
        self.labels.removeAll()
        self.x_stretches.removeAll()
        self.x_shifts.removeAll()
        self.trigger_left.removeAll()
        self.trigger_right.removeAll()
        self.current_selection_index = -1
        self.presumed_selection_index = 0
        //create labels
        var color = UIColor.white
        if #available(iOS 13, *) {
            color = UIColor.label
        }
        for item in self.items {
            let label = UILabel.init()
            label.text = item
            label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            label.textColor = color
            let size = label.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            label.frame = .init(origin: .zero, size: size)
            self.labels.append(label)
        }
        //position labels
        let left_inset = self.frame.width / 2
        let right_inset = self.frame.width / 2 - (self.labels.last?.bounds.midX ?? 0)
        var accumulated_width: CGFloat = 0
        let gap: CGFloat = 70
        for (n, label) in self.labels.enumerated() {
            self.scroll_view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: self.scroll_view.leadingAnchor, constant: left_inset + accumulated_width + CGFloat(n) * gap).isActive = true
            label.centerYAnchor.constraint(equalTo: self.scroll_view.centerYAnchor).isActive = true
            accumulated_width += label.bounds.width
        }
        self.layoutIfNeeded()
        self.scroll_view.contentSize = .init(width: (self.labels.last?.frame.maxX ?? 100) + right_inset, height: self.labels.last?.frame.height ?? 56)
        for label in self.labels {
            let left_trigger = label.frame.minX - label.bounds.width / 2 - self.scroll_view.bounds.width / 2
            let right_trigger = label.frame.maxX + label.bounds.width / 2 - self.scroll_view.bounds.width / 2
            self.trigger_left.append(left_trigger)
            self.trigger_right.append(right_trigger)
            let x_stretch = (max_scale - 1) / (label.frame.midX - left_trigger)
            let x_shift = (left_trigger + right_trigger) / 2
            self.x_stretches.append(x_stretch)
            self.x_shifts.append(x_shift)
        }
        self.updateLabelsTransform(content_offset: self.scroll_view.contentOffset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 12.0, *) {
            let user_interface_style = self.traitCollection.userInterfaceStyle
            if user_interface_style == .dark {
//                self.alpha = 0.7
//                self.backgroundColor = UIColor.white
//                for label in self.labels {
//                    label.textColor = UIColor.black.withAlphaComponent(0.7)
//                }
//                self.indicator_layer?.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor
//                self.left_gradient_layer?.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
//                self.right_gradient_layer?.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
            } else {
//                self.alpha = 1.0
//                self.backgroundColor = UIColor.init(hex: "474747")
//                for label in self.labels {
//                    label.textColor = UIColor.white
//                }
//                self.indicator_layer?.fillColor = UIColor.white.cgColor
//                self.left_gradient_layer?.colors = [UIColor.init(hex: "474747").cgColor, UIColor.init(hex: "474747").withAlphaComponent(0).cgColor]
//                self.right_gradient_layer?.colors = [UIColor.init(hex: "474747").withAlphaComponent(0).cgColor, UIColor.init(hex: "474747").cgColor]
            }
        }
    }
    
    func updateLabelsTransform(content_offset: CGPoint) {
        for (n, left_trigger) in self.trigger_left.enumerated() {
            //scale
            let right_trigger = self.trigger_right[n]
            let mid = (left_trigger + right_trigger) / 2
            var scale: CGFloat = 1
            if left_trigger <= content_offset.x && content_offset.x <= mid {
                let ratio = (content_offset.x - left_trigger) / (mid - left_trigger)
                scale = 1 + ratio * (self.max_scale - 1)
                self.labels[n].transform = CGAffineTransform.init(scaleX: scale, y: scale)
            } else if content_offset.x > mid && content_offset.x <= right_trigger {
                let ratio = (content_offset.x - mid) / (right_trigger - mid)
                scale = self.max_scale - ratio * (self.max_scale - 1)
                self.labels[n].transform = CGAffineTransform.init(scaleX: scale, y: scale)
            } else {
                self.labels[n].transform = .identity
            }
            //feedback
            if content_offset.x < mid + self.labels[n].bounds.width / 2 && content_offset.x > mid - self.labels[n].bounds.width / 2 {
                if n != self.presumed_selection_index {
                    self.presumed_selection_index = n
                    self.feedback_generator?.selectionChanged()
                }
            }
        }
    }
    
    // MARK: - User Interaction
    
    @objc func scrollviewTapped(_ sender: UITapGestureRecognizer) {
//        let location = sender.location(in: self)
//        let converted_location = CGPoint.init(x: location.x + self.scroll_view.contentOffset.x, y: location.y)
//        var index: Int = -1
//        for (n, label) in self.labels.enumerated() {
//            if label.frame.contains(converted_location) {
//                index = n
//                break
//            }
//        }
//        self.scrollToIndex(index)
//        self.presumed_selection_index = index
//        if self.presumed_selection_index != self.current_selection_index {
//            self.delegate?.horizontalPickerView(self, didSelectItemAtIndex: self.presumed_selection_index)
//            self.current_selection_index = self.presumed_selection_index
//        }
    }
    
    func scrollToIndex(_ index: Int) {
        if index >= 0 && index < self.labels.count {
            let x = (self.trigger_left[index] + self.trigger_right[index]) / 2
            let target_content_offset = CGPoint.init(x: x, y: 0)
            self.scroll_view.setContentOffset(target_content_offset, animated: true)
            self.indicator_layer?.opacity = 1.0
        }
    }
    
}

// MARK: - Scroll View

extension HorizontalPickerView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.feedback_generator?.prepare()
        self.indicator_layer?.opacity = 0.7
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateLabelsTransform(content_offset: scrollView.contentOffset)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollToIndex(self.presumed_selection_index)
        if self.presumed_selection_index != self.current_selection_index {
            self.delegate?.horizontalPickerView(self, didSelectItemAtIndex: self.presumed_selection_index)
            self.current_selection_index = self.presumed_selection_index
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
}
