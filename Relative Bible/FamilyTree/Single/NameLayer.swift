//
//  NameLayer.swift
//  Bible
//
//  Created by Peter Ke on 2019-10-11.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class NameLayer: CAShapeLayer {
    
    var id: Int = -1
    
    var text_layer: CATextLayer!
    
    var is_root: Bool = false
    
    static let container_colors = [
        UIColor.init(hex: "474747").cgColor,
        UIColor.init(hex: "FFD9E0").cgColor,
        UIColor.init(hex: "E6D6EF").cgColor
    ]
    
    static let root_stroke_color = UIColor.init(hex: "979797").cgColor
    
    init(id: Int, is_root: Bool) {
        super.init()
        self.id = id
        self.is_root = is_root
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        let gender = BibleData.gender(id: self.id)
        let name = BibleData.characterName(id: self.id)
        self.text_layer = CATextLayer.init()
        self.text_layer.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        self.text_layer.fontSize = 17
        if self.is_root {
            self.text_layer.foregroundColor = UIColor.white.cgColor
        } else {
            self.text_layer.foregroundColor = NameLayer.container_colors[0]
        }
        self.text_layer.contentsScale = UIScreen.main.scale
        self.text_layer.alignmentMode = .center
        self.text_layer.string = name
        let text_size = self.text_layer.preferredFrameSize()
        self.text_layer.bounds = CGRect.init(origin: .zero, size: text_size)
        self.text_layer.anchorPoint = .init(x: 0.5, y: 0.5)
        self.addSublayer(self.text_layer)
        self.bounds = .init(x: 0, y: 0, width: text_size.width + 30, height: 40)
        self.text_layer.position = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
        self.path = CGPath.init(roundedRect: self.bounds, cornerWidth: 20, cornerHeight: 20, transform: nil)
        if self.is_root {
            self.fillColor = NameLayer.container_colors[0]
            self.lineWidth = 1
            self.strokeColor = NameLayer.root_stroke_color
        } else {
            if gender == 1 {
                //female
                self.fillColor = NameLayer.container_colors[1]
                self.shadowColor = NameLayer.container_colors[1]
            } else {
                //male
                self.fillColor = NameLayer.container_colors[2]
                self.shadowColor = NameLayer.container_colors[2]
            }
            self.shadowPath = self.path
            self.shadowOpacity = 0.5
            self.shadowOffset = .zero
            self.shadowRadius = 5
        }
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextSize(font_size: CGFloat) {
        self.text_layer.fontSize = font_size
        let text_size = self.text_layer.preferredFrameSize()
        self.text_layer.bounds = CGRect.init(origin: .zero, size: text_size)
        self.bounds = .init(x: 0, y: 0, width: text_size.width + 30, height: text_size.height + 20)
        self.text_layer.position = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
        self.path = CGPath.init(roundedRect: self.bounds, cornerWidth: self.bounds.height / 2, cornerHeight: self.bounds.height / 2, transform: nil)
        self.shadowPath = self.path
    }
    
}

