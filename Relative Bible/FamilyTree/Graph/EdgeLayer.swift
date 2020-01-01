//
//  EdgeLayer.swift
//  Bible
//
//  Created by Jun Ke on 8/10/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class EdgeLayer: CAShapeLayer {
    
    var source: Int!
    var destination: Int!
    var rank: Rank!
    
    static let rank_alpha: [Rank : Float] = [
        Rank.low : 0.5,
        Rank.medium : 0.7,
        Rank.high : 1.0
    ]
    
    static let rank_line_width: [Rank : CGFloat] = [
        Rank.low : 3,
        Rank.medium : 4,
        Rank.high : 5
    ]
    
    override init() {
        super.init()
        self.bounds = CGRect.init(x: 0, y: 0, width: 100, height: 10)
        self.path = CGPath.init(rect: self.bounds, transform: nil)
        self.rank = .medium
        self.anchorPoint = CGPoint.init(x: 0, y: 0)
        self.contentsScale = UIScreen.main.scale
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    func setRank(_ rank: Rank) {
        self.rank = rank
        self.opacity = EdgeLayer.rank_alpha[self.rank] ?? 1.0
        self.lineWidth = EdgeLayer.rank_line_width[self.rank] ?? 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjust_orientation(src_layer s_layer: CharacterLayer, des_layer d_layer: CharacterLayer, relationship: Relationship?) {
        self.position = CGPoint.init(x: min(s_layer.frame.midX, d_layer.frame.midX), y: min(s_layer.frame.midY, d_layer.frame.midY))
        self.bounds = CGRect.init(x: 0, y: 0, width: abs(s_layer.frame.midX - d_layer.frame.midX), height: abs(s_layer.frame.midY - d_layer.frame.midY))
        let slope = (s_layer.frame.midY - d_layer.frame.midY) / (s_layer.frame.midX - d_layer.frame.midX)
        if let rl = relationship {
            self.strokeColor = rl.color.cgColor
            //text
//            let text_layer = CATextLayer.init()
//            text_layer.bounds = self.bounds
//            text_layer.anchorPoint = .init(x: 0.5, y: 0.5)
//            text_layer.font = UIFont.systemFont(ofSize: 10, weight: .medium)
//            text_layer.fontSize = 17
//            if s_layer.frame.midX < d_layer.frame.midX {
//                text_layer.string = rl.rawValue + " >>"
//            } else if s_layer.frame.midX > d_layer.frame.midX {
//                text_layer.string = "<< " + rl.rawValue
//            } else {
//                text_layer.string = rl.rawValue + " >>"
//            }
//            text_layer.alignmentMode = .center
//            text_layer.contentsScale = UIScreen.main.scale
//            text_layer.bounds = .init(origin: .zero, size: text_layer.preferredFrameSize())
//            text_layer.position = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
//            text_layer.foregroundColor = rl.color.cgColor
//            self.addSublayer(text_layer)
//            let angle = atan(slope)
//            //broken line path
//            let radius = self.bounds.diagonal_length
//            let path = UIBezierPath.init()
//            let piece_length = (radius - text_layer.bounds.width) / 2
//            if slope.sign == .plus {
//                path.move(to: .init(x: self.bounds.maxX, y: self.bounds.maxY))
//                path.addLine(to: .init(x: self.bounds.maxX - piece_length * cos(angle), y: self.bounds.maxY - piece_length * sin(angle)))
//                path.move(to: .zero)
//                path.addLine(to: .init(x: piece_length * cos(angle), y: self.bounds.minY + piece_length * sin(angle)))
//            } else {
//                path.move(to: .init(x: self.bounds.minX, y: self.bounds.maxY))
//                path.addLine(to: .init(x: piece_length * cos(angle), y: self.bounds.maxY + piece_length * sin(angle)))
//                path.move(to: .init(x: (piece_length + text_layer.bounds.width) * cos(angle), y: self.bounds.minX - piece_length * sin(angle)))
//                path.addLine(to: .init(x: self.bounds.maxX, y: self.bounds.minY))
//            }
            //line path
            let path = UIBezierPath.init()
            if slope.sign == .plus {
                path.move(to: .zero)
                path.addLine(to: CGPoint.init(x: self.bounds.maxX, y: self.bounds.maxY))
                path.close()
            } else {
                path.move(to: CGPoint.init(x: self.bounds.minX, y: self.bounds.maxY))
                path.addLine(to: .init(x: self.bounds.maxX, y: self.bounds.minY))
                path.close()
            }
            self.path = path.cgPath
            //transform text
//            text_layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        } else {
            //line path
            let path = UIBezierPath.init()
            if slope.sign == .plus {
                path.move(to: .zero)
                path.addLine(to: CGPoint.init(x: self.bounds.maxX, y: self.bounds.maxY))
                path.close()
            } else {
                path.move(to: CGPoint.init(x: self.bounds.minX, y: self.bounds.maxY))
                path.addLine(to: .init(x: self.bounds.maxX, y: self.bounds.minY))
                path.close()
            }
            self.path = path.cgPath
        }
        self.zPosition = 100
    }
    
    enum Rank {
        case low
        case medium
        case high
    }
    
}
