//
//  Place.swift
//  Theographic
//
//  Created by Jun Ke on 8/1/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

class GraphQL_Place {
    
    var id: String?
    var name: String?
    var alsoCalled: [String]?
    var latitude: Double?
    var longitude: Double?
    var precision: String?
    var featureType: String?
    var description: String?
    var source: String?
    var comments: String?
    var verseCount: Int?
    var hasBeenThere: [GraphQL_Person]?
    var peopleBorn: [GraphQL_Person]?
    var peopleDied: [GraphQL_Person]?
    
    init() {
        
    }
    
}

