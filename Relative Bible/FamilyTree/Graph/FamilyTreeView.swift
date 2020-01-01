//
//  FamilyTreeView.swift
//  Bible
//
//  Created by Peter Ke on 2019-10-07.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

fileprivate let pi = CGFloat.pi

typealias LayoutSize = (edge_length_1: CGFloat, edge_length_2: CGFloat, second_angular_offset: CGFloat, font_sizes: [CharacterLayer.Size : CGFloat])

protocol FamilyTreeViewDelegate: class {
    func familyTreeView(_ familyTreeView: FamilyTreeView, didSelectWithID id: Int)
}

class FamilyTreeView: UIView {

    weak var delegate: FamilyTreeViewDelegate?
    
    //data
    var family_tree: FamilyTree!
    var ft_loaded: Bool = false
    
    //UI
    var container_layer: CALayer!
    var character_layers: [Int: CharacterLayer] = [:]
    var edge_layers: [EdgeLayer] = []
    
    //blueprint
    var root: Int = -1
    var previous_root_stack: Stack<Int> = Stack()
    var first_relatives: [Int] = []
    var second_relatives: [Int] = []
    var first_second_connections: [Int: [Int]] = [:]
    
    //initializers
    init(frame: CGRect, family_tree: FamilyTree) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            self.backgroundColor = UIColor.systemGray6
        } else {
            self.backgroundColor = UIColor.white
        }
        self.family_tree = family_tree
        self.container_layer = CALayer.init()
        self.container_layer.frame = self.bounds
        self.container_layer.anchorPoint = .init(x: 0.5, y: 0.5)
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
                self.character_layers[self.root]?.fillColor = UIColor.white.cgColor
                self.character_layers[self.root]?.text_layer.foregroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
            } else {
                self.character_layers[self.root]?.fillColor = NameLayer.container_colors[0]
                self.character_layers[self.root]?.text_layer.foregroundColor = UIColor.white.cgColor
            }
        }
    }
    
    static let standard_size: LayoutSize = (200, 250, 5 * pi / 180, CharacterLayer.size_font_size)
    var current_size = FamilyTreeView.standard_size
    let step_ratio: CGFloat = 0.8
    
    func incrementSize() {
        self.current_size.edge_length_1 /= self.step_ratio
        self.current_size.edge_length_2 /= self.step_ratio
        self.current_size.font_sizes = self.current_size.font_sizes.mapValues({ $0 + 1 })
        self.layout(withLayoutSize: self.current_size)
    }
    
    func decrementSize() {
        self.current_size.edge_length_1 *= self.step_ratio
        self.current_size.edge_length_2 *= self.step_ratio
        self.current_size.font_sizes = self.current_size.font_sizes.mapValues({ $0 - 1 })
        self.layout(withLayoutSize: self.current_size)
    }
    
    func layout(withLayoutSize layout_size: LayoutSize) {
        //update font size
        CharacterLayer.size_font_size = layout_size.font_sizes
        //clear edges
        for e_layer in self.edge_layers {
            e_layer.removeFromSuperlayer()
        }
        self.edge_layers.removeAll()
        //remove irrelevant
        let present_ids = self.character_layers.keys
        let combined_relatives = self.first_relatives + second_relatives + [self.root]
        for layer_id in present_ids {
            if !combined_relatives.contains(layer_id) {
                let c_layer = self.character_layers[layer_id]
                c_layer?.removeFromSuperlayer()
                self.character_layers.removeValue(forKey: layer_id)
            }
        }
        //add relevant
        for id in combined_relatives {
            if !present_ids.contains(id) {
                let c_layer = CharacterLayer.init(id: id, is_root: false)
                c_layer.zPosition = 101
                self.character_layers[id] = c_layer
                self.container_layer.addSublayer(c_layer)
            }
        }
        //appearance
        for id in combined_relatives {
            self.character_layers[id]?.set_root(false)
            self.character_layers[id]?.setHighlight(.unfocused)
        }
        self.character_layers[self.root]?.set_root(true)
        self.character_layers[self.root]?.setHighlight(.focused)
        self.character_layers[self.previous_root_stack.peek() ?? -1]?.setHighlight(.semifocused)
        //set position
        let center_x = self.container_layer.bounds.width / 2
        let center_y = self.container_layer.bounds.height / 2
        self.character_layers[self.root]?.position = CGPoint.init(x: center_x, y: center_y)
        self.character_layers[self.root]?.setSize(.large)
        let first_count = self.first_relatives.count
        let angular_interval = 2 * pi / CGFloat(first_count)
        for (n, id) in self.first_relatives.enumerated() {
            //first relative
            let angle = CGFloat(n) * angular_interval
            let x = cos(angle) * layout_size.edge_length_1
            let y = sin(angle) * layout_size.edge_length_1
            let first_position = CGPoint.init(x: center_x + x, y: center_y + y)
            self.character_layers[id]?.position = first_position
            self.character_layers[id]?.setSize(.medium)
            //second relatives
            let sr = self.first_second_connections[id]!
            let sr_count = sr.count
            let second_angular_interval = (sr.map({ self.character_layers[$0] }).compactMap({ $0?.bounds.width }).max() ?? 50) / layout_size.edge_length_2
            if sr_count % 2 == 0 {
                //even number of second relatives
                let span = CGFloat(sr_count - 1) * layout_size.second_angular_offset + CGFloat(sr_count) * second_angular_interval
                let min_angle = angle - span / 2
                for m in 0..<sr_count {
                    let theta = min_angle + CGFloat(m) * (second_angular_interval + layout_size.second_angular_offset)
                    let sr_x = first_position.x + cos(theta) * layout_size.edge_length_2
                    let sr_y = first_position.y + sin(theta) * layout_size.edge_length_2
                    self.character_layers[sr[m]]?.position = CGPoint.init(x: sr_x, y: sr_y)
                    self.character_layers[sr[m]]?.setSize(.small)
                }
            } else {
                let span = CGFloat(sr_count) * second_angular_interval + CGFloat(sr_count - 1) * layout_size.second_angular_offset
                let min_angle = angle - span / 2
                for m in 0..<sr_count {
                    let theta = min_angle + CGFloat(m) * (second_angular_interval + layout_size.second_angular_offset)
                    let sr_x = first_position.x + cos(theta) * layout_size.edge_length_2
                    let sr_y = first_position.y + sin(theta) * layout_size.edge_length_2
                    self.character_layers[sr[m]]?.position = CGPoint.init(x: sr_x, y: sr_y)
                    self.character_layers[sr[m]]?.setSize(.small)
                }
            }
        }
        self.layoutEdges()
    }
    
    func layoutEdges() {
        //root - first; first - first; first - second; second - second
        let ids = self.first_relatives + self.second_relatives + [self.root]
        //right-exclusive bounds of three parts
        let fr_bound = self.first_relatives.count
        let sr_bound = self.second_relatives.count + fr_bound
        let c_count = ids.count
        var i: Int = 0
        var j: Int = 0
        while i < c_count - 1 {
            j = i + 1
            while j < c_count {
                if let relationship = self.family_tree.relationship(between: ids[i], and: ids[j]) {
                    //create edge
                    let e_layer = EdgeLayer.init()
                    //rank of edge
                    var r_1: Int, r_2: Int
                    if i < fr_bound {
                        r_1 = 2
                    } else if i < sr_bound {
                        r_1 = 1
                    } else {
                        r_1 = 3
                    }
                    if j < fr_bound {
                        r_2 = 2
                    } else if j < sr_bound {
                        r_2 = 1
                    } else {
                        r_2 = 3
                    }
                    if r_1 + r_2 == 5 {
                        e_layer.setRank(.high)
                    } else if (r_1 + r_2) % 2 == 0 {
                        e_layer.setRank(.low)
                    } else {
                        e_layer.setRank(.medium)
                    }
                    //orient edge
                    e_layer.adjust_orientation(src_layer: self.character_layers[ids[i]]!, des_layer: self.character_layers[ids[j]]!, relationship: relationship)
                    //add edge
                    self.edge_layers.append(e_layer)
                    self.container_layer.addSublayer(e_layer)
                }
                j += 1
            }
            i += 1
        }
    }
    
    func resetRoot(withCharacterID id: Int) {
        //update root
        if self.root == -1 {
            self.previous_root_stack.clear()
        } else if self.previous_root_stack.peek() == id {
            _ = self.previous_root_stack.pop()
        } else {
            self.previous_root_stack.push(element: self.root)
        }
        self.root = id
        //update relatives
        self.first_relatives = self.family_tree.firstLevelRelatives(of: id)
        self.first_second_connections.removeAll()
        self.second_relatives.removeAll()
        for fr in self.first_relatives {
            let sr = self.family_tree.firstLevelRelatives(of: fr).filter({ $0 != self.root && !self.first_relatives.contains($0) })
            self.second_relatives.append(contentsOf: sr)
            self.first_second_connections[fr] = sr
        }
    }
    
    //user interaction
    var touch_on_container: Bool = false
    var touch_down_location: CGPoint = .zero
    var container_location_at_touch_down: CGPoint = .zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touch_down_location = touch.location(in: self)
        self.container_location_at_touch_down = self.container_layer.position
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touch_location = touch.location(in: self)
        let translated_location = CGPoint.init(x: touch_location.x - self.touch_down_location.x + self.container_location_at_touch_down.x, y: touch_location.y - self.touch_down_location.y + container_location_at_touch_down.y)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.container_layer.position = translated_location
        CATransaction.commit()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touch_location = touch.location(in: self)
        let touch_up_container_location = self.convertToContainerLocation(touch_location)
        if self.locationsEqualWithinLimits(p1: touch_up_container_location, p2: self.convertToContainerLocation(self.touch_down_location)) {
            //touch on a node or not
            var selected_id: Int = -1
            for (id, layer) in self.character_layers {
                if layer.frame.contains(touch_up_container_location) {
                    selected_id = id
                    break
                }
            }
            if selected_id != -1 {
                self.setRoot(selected_id)
            }
        }
    }
    
    func setRoot(_ root: Int) {
        if root != self.root {
            self.resetRoot(withCharacterID: root)
            self.layout(withLayoutSize: self.current_size)
            self.delegate?.familyTreeView(self, didSelectWithID: root)
        }
    }
        
    func convertToContainerLocation(_ location: CGPoint) -> CGPoint {
        let delta_x = container_layer.frame.minX
        let delta_y = container_layer.frame.minY
        return CGPoint.init(x: location.x - delta_x, y: location.y - delta_y)
    }
    
    func locationsEqualWithinLimits(p1: CGPoint, p2: CGPoint) -> Bool {
        return euclidianDistance(p1: p1, p2: p2) <= 5
    }
    
    func euclidianDistance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let delta_x = p1.x - p2.x
        let delta_y = p1.y - p2.y
        return sqrt(delta_x * delta_x + delta_y * delta_y)
    }
    
}
