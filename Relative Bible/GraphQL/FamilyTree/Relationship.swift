//
//  Relationship.swift
//  BiblicalPersonsGraph
//
//  Created by Jun Ke on 8/8/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

public enum Relationship: String {
    case HalfSiblingsSameFather = "Half Siblings Same Father"
    case HalfSiblingsSameMother = "Half Siblings Same Mother"
    case Siblings = "Siblings"
    case Son = "Son"
    case Daughter = "Daughter"
    case Father = "Father"
    case Mother = "Mother"
    case Partner = "Partner"
    
    var literal: String {
        return self.rawValue + " of"
    }
    
    static let all_cases: [Relationship] = [.Father, .Mother, .Partner, .Son, .Daughter, .Siblings, .HalfSiblingsSameFather, .HalfSiblingsSameMother]
    
    static let common_cases: [Relationship] = [.Father, .Mother, .Partner, .Son, .Daughter]
    
    var shortened: String {
        switch self {
        case .HalfSiblingsSameFather:
            return "H.S.S.F."
        case .HalfSiblingsSameMother:
            return "H.S.S.M."
        default:
            return self.rawValue
        }
    }
    
    var color: UIColor {
        switch self {
        case .Son:
            return UIColor.init(hex: "F7B500")
        case .Daughter:
            return UIColor.init(hex: "FA6400")
        case .Father:
            return UIColor.init(hex: "6236FF")
        case .Mother:
            return UIColor.init(hex: "B620E0")
        case .Partner:
            return UIColor.init(hex: "92BA45")
        default:
            return UIColor.black.withAlphaComponent(0.7)
        }
    }
}

