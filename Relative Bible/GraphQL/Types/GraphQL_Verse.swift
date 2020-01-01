//
//  Verse.swift
//  Theographic
//
//  Created by Jun Ke on 8/1/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

class GraphQL_Verse {
    
    var id: String?
    var osisRef: String?
    var fullRef: String?
    var chapter: GraphQL_Chapter?
    var title: String?
    var people: [GraphQL_Person]?
    var places: [GraphQL_Place]?
    
    init() {
        
    }
    
}

