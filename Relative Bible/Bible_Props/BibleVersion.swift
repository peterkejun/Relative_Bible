//
//  BibleVersion.swift
//  Bible
//
//  Created by Jun Ke on 8/19/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

enum BibleVersion: String {
    case KJV = "KJV"
    case CUV_sim = "CUV SIM"
    case CUV_tra = "CUV TRA"
    case ASV = "ASV"
    case JCL = "JCL"
    case JCO = "JCO"
    case KRV = "KRV"
    case LSG = "LSG"
    case GLO = "GLO"
    case GLM = "GLM"
}

extension BibleVersion {
    static let all: [BibleVersion] = [
        .KJV, .CUV_sim, .CUV_tra, .ASV, .JCL, .JCO, .KRV, .LSG, .GLO, .GLM
    ]
    
    var literal: String {
        return bibleVersionLiteral[self]!
    }
    
    var nativeLiteral: String {
        return bibleVersionLiteralNative[self]!
    }
    
    var image: UIImage {
        return UIImage.init(named: self.rawValue)!
    }
}

let bibleVersionLiteral: [BibleVersion: String] = [
    BibleVersion.KJV: "King James Version",
    BibleVersion.CUV_sim: "Chinese Union Version (Simplified)",
    BibleVersion.CUV_tra: "Chinese Union Version (traditional)",
    BibleVersion.ASV: "American Standard Version",
    BibleVersion.JCL: "Japanese Classical",
    BibleVersion.JCO: "Japanese Colloquial",
    BibleVersion.KRV: "Korean Revised Version",
    BibleVersion.LSG: "French Louis Segond",
    BibleVersion.GLO: "German Luther Original",
    BibleVersion.GLM: "German Luther Modern"
]

let bibleVersionLiteralNative: [BibleVersion: String] = [
    BibleVersion.KJV: "King James Version",
    BibleVersion.CUV_sim: "简体和合本",
    BibleVersion.CUV_tra: "繁体和合本",
    BibleVersion.ASV: "American Standard Version",
    BibleVersion.JCL: "文語訳聖書",
    BibleVersion.JCO: "口語訳聖書",
    BibleVersion.KRV: "개역한글",
    BibleVersion.LSG: "Louis Segond",
    BibleVersion.GLO: "Lutherbibel (Original)",
    BibleVersion.GLM: "Lutherbibel (Modern)"
]


