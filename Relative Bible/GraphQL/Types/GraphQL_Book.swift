//
//  Book.swift
//  Theographic
//
//  Created by Jun Ke on 8/1/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

class GraphQL_Book {
    
    var id: String?
    var osisRef: String?
    var title: String?
    var shortName: String?
    var writers: [GraphQL_Person]?
    var chapters: [GraphQL_Chapter]?
    
    init() {
        
    }
    
}


