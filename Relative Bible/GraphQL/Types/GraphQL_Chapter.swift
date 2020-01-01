//
//  Chapter.swift
//  Theographic
//
//  Created by Jun Ke on 8/1/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

class GraphQL_Chapter {
    
    var id: String?
    var title: String?
    var osisRef: String?
    var book: GraphQL_Book?
    var verses: [GraphQL_Verse]?
    var writers: [GraphQL_Person]?
    
    init() {
        
    }
    
}

