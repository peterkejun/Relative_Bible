//
//  SingleRelationshipView.swift
//  Bible
//
//  Created by Peter Ke on 2019-10-11.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class SingleRelationshipView: UIView {

    var relationship: Relationship!
    var root: Int = -1
    var name_layers: [Int: NameLayer] = [:]
    var rope_layers: [CAShapeLayer] = []
    var root_layer: NameLayer?
    
    var container_layer: CALayer!
    
    var family_tree: FamilyTree!
    
    static let rope_color = UIColor.init(hex: "F7B500").cgColor
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13, *) {
            self.backgroundColor = UIColor.systemGray6
        } else {
            self.backgroundColor = UIColor.white
        }
        self.container_layer = CALayer.init()
        self.container_layer.frame = self.bounds
        self.container_layer.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(self.container_layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 12.0, *) {
            let user_interface_style = self.traitCollection.userInterfaceStyle
            if user_interface_style == .dark {
                self.root_layer?.fillColor = UIColor.white.cgColor
                self.root_layer?.text_layer.foregroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
            } else {
                self.root_layer?.fillColor = NameLayer.container_colors[0]
                self.root_layer?.text_layer.foregroundColor = UIColor.white.cgColor
            }
        }
    }
    
    func clear() {
        if let sublayers = self.container_layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        self.name_layers.removeAll()
        self.rope_layers.removeAll()
    }
    
    func setHidden(_ flag: Bool) {
        self.container_layer.isHidden = flag
    }
    
    func redraw() {
        //update root
        self.clear()
        //update layers
        self.root_layer = NameLayer.init(id: self.root, is_root: true)
        let relatives = family_tree.relativesOf(id: self.root, withRelationship: self.relationship)
        for r in relatives {
            let n_layer = NameLayer.init(id: r, is_root: false)
            self.name_layers[r] = n_layer
        }
        //position layers
        self.root_layer!.position = .init(x: self.bounds.width * 0.2, y: self.bounds.midY)
        self.root_layer!.zPosition = 101
        let r_count = self.name_layers.count
        let max_width = self.name_layers.map({ $0.value.bounds.width }).max() ?? self.root_layer!.bounds.width
        let trailing_gap: CGFloat = 30
        let gap = r_count == 1 ? 0 : self.root_layer!.bounds.height / CGFloat(self.name_layers.count - 1)
        let span = CGFloat(r_count) * self.root_layer!.bounds.height + CGFloat(r_count - 1) * gap
        let low_start = self.root_layer!.position.y - span / 2
        for (r, r_layer) in self.name_layers.values.enumerated() {
            let x = self.bounds.width - trailing_gap - max_width / 2
            let y = low_start + CGFloat(r) * (gap + r_layer.bounds.height) + r_layer.bounds.height / 2
            r_layer.position = .init(x: x, y: y)
            r_layer.zPosition = 101
        }
        //add ropes
        for n_layer in self.name_layers.values {
            let k = n_layer.position.y - self.root_layer!.position.y
            let h = (n_layer.position.x - self.root_layer!.position.x) * 2 / 3
            let rope_layer = CAShapeLayer.init()
            rope_layer.bounds = .init(x: 0, y: 0, width: abs(n_layer.frame.midX - self.root_layer!.frame.midX), height: abs(n_layer.frame.midY - self.root_layer!.frame.midY))
            rope_layer.anchorPoint = .init(x: 0, y: 0)
            rope_layer.position = CGPoint.init(x: self.root_layer!.position.x, y: min(n_layer.position.y, self.root_layer!.position.y))
            let path = UIBezierPath.init()
            if n_layer.position.y >= self.root_layer!.position.y {
                //curve concave up
                let control_point = CGPoint.init(x: h / 2, y: k)
                path.move(to: .init(x: rope_layer.bounds.minX, y: rope_layer.bounds.minY))
                path.addQuadCurve(to: .init(x: rope_layer.bounds.maxX * 2 / 3, y: rope_layer.bounds.maxY), controlPoint: control_point)
                path.addLine(to: .init(x: rope_layer.bounds.maxX, y: rope_layer.bounds.maxY))
            } else {
                //curve concave down
                let control_point = CGPoint.init(x: h / 2, y: 0)
                path.move(to: .init(x: rope_layer.bounds.minX, y: rope_layer.bounds.maxY))
                path.addQuadCurve(to: .init(x: rope_layer.bounds.maxX * 2 / 3, y: rope_layer.bounds.minY), controlPoint: control_point)
                path.addLine(to: .init(x: rope_layer.bounds.maxX, y: rope_layer.bounds.minY))
            }
            rope_layer.path = path.cgPath
            rope_layer.lineWidth = 3
            rope_layer.fillColor = UIColor.clear.cgColor
            rope_layer.strokeColor = SingleRelationshipView.rope_color
            rope_layer.strokeEnd = 0
            rope_layer.zPosition = 100
            self.rope_layers.append(rope_layer)
        }
        //add layers
        self.container_layer.addSublayer(self.root_layer!)
        for (_, n_layer) in self.name_layers {
            self.container_layer.addSublayer(n_layer)
        }
        for r_layer in self.rope_layers {
            self.container_layer.addSublayer(r_layer)
        }
        if #available(iOS 12.0, *) {
            let user_interface_style = self.traitCollection.userInterfaceStyle
            if user_interface_style == .dark {
                self.root_layer?.fillColor = UIColor.white.cgColor
                self.root_layer?.text_layer.foregroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
            } else {
                self.root_layer?.fillColor = NameLayer.container_colors[0]
                self.root_layer?.text_layer.foregroundColor = UIColor.white.cgColor
            }
        }
        //animation
        let animation = CABasicAnimation.init(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        animation.duration = 0.7
        for r_layer in self.rope_layers {
            r_layer.add(animation, forKey: "animate stroke end")
            r_layer.strokeEnd = 1
        }
    }
    
    func set(root id: Int, relationship: Relationship, family_tree: FamilyTree, show: Bool = true) {
        self.relationship = relationship
        self.root = id
        self.family_tree = family_tree
        self.setHidden(!show)
        self.redraw()
    }
    
    func preferredBounds() -> CGRect {
        let min_x = root_layer!.frame.minX
        let max_x = self.name_layers.values.map({ $0.frame.maxX }).max() ?? (self.bounds.width)
        let min_y = self.name_layers.values.map({ $0.frame.minY }).min() ?? 0
        let max_y = self.name_layers.values.map({ $0.frame.maxY }).max() ?? (self.bounds.height)
        return CGRect.init(x: 0, y: 0, width: max_x - min_x, height: max_y - min_y)
    }
    
}
