//
//  UIView+Extensions.swift
//  Bible
//
//  Created by Jun Ke on 8/1/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension UIView {
    
    func setGradientBackground(top: UIColor, bottom: UIColor, cornerRadius: CGFloat = 0, maskedCorners: CACornerMask? = nil) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [top.cgColor, bottom.cgColor]
        gradientLayer.cornerRadius = cornerRadius
        if let mc = maskedCorners {
            gradientLayer.maskedCorners = mc
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
    
    func showActivityIndicator(style: UIActivityIndicatorView.Style = .white) {
        if let ai = self.viewWithTag(100000) as? UIActivityIndicatorView {
            ai.style = style
            ai.startAnimating()
            return
        }
        let ai = UIActivityIndicatorView.init(style: style)
        ai.tag = 100000
        self.addSubview(ai)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ai.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.layoutIfNeeded()
        ai.startAnimating()
    }
    
    func removeActivityIndicator() {
        if let ai = self.viewWithTag(100000) as? UIActivityIndicatorView {
            ai.stopAnimating()
            ai.removeFromSuperview()
        }
    }
    
    var renderedImage: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
}

