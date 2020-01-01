//
//  CharacterLayer.swift
//  Bible
//
//  Created by Peter Ke on 2019-10-07.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class CharacterLayer: NameLayer {
    
    static let highlight_color = UIColor.yellow.cgColor
    static let unhighligh_color = UIColor.black.cgColor
    
    static let hightlight_colors: [HighlightType : CGColor] = [
        HighlightType.focused : NameLayer.root_stroke_color,
        HighlightType.semifocused : SingleRelationshipView.rope_color,
        HighlightType.unfocused : UIColor.clear.cgColor
    ]
    
    static let hightlight_line_widths: [HighlightType : CGFloat] = [
        HighlightType.focused : 1,
        HighlightType.semifocused : 3,
        HighlightType.unfocused : 0
    ]
    
    static var size_font_size: [Size : CGFloat] = [
        Size.large : 20,
        Size.medium : 16,
        Size.small : 12
    ]
    
    func set_root(_ flag: Bool) {
        if flag == self.is_root {
            return
        }
        self.is_root = flag
        if self.is_root {
            self.text_layer.foregroundColor = UIColor.white.cgColor
            self.fillColor = NameLayer.container_colors[0]
            self.lineWidth = 1
            self.strokeColor = NameLayer.root_stroke_color
        } else {
            self.lineWidth = 0
            self.strokeColor = nil
            self.text_layer.foregroundColor = NameLayer.container_colors[0]
            if BibleData.gender(id: self.id) == 1 {
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
    
    func setHighlight(_ type: HighlightType) {
        self.strokeColor = CharacterLayer.hightlight_colors[type]
        self.lineWidth = CharacterLayer.hightlight_line_widths[type] ?? 0
    }
    
    func setSize(_ size: Size) {
        self.setTextSize(font_size: CharacterLayer.size_font_size[size] ?? 16)
    }
    
    enum HighlightType {
        case focused
        case semifocused
        case unfocused
    }
    
    enum Size {
        case large
        case medium
        case small
    }
    
}
