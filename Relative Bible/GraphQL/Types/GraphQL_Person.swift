//
//  Person.swift
//  Theographic
//
//  Created by Jun Ke on 8/1/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

class GraphQL_Person {
    
    var id: String?
    var name: String?
    var gender: Gender?
    var alsoCalled: [String]?
    var description: String?
    var birthPlace: [GraphQL_Place]?
    var deathPlace: [GraphQL_Place]?
    var birthYear: [GraphQL_Year]?
    var deathYear: [GraphQL_Year]?
    var memberOf: [GraphQL_PeopleGroup]?
    var writerOf: [GraphQL_Book]?
    var hasBeenTo: [GraphQL_Place]?
    var partnerOf: [GraphQL_Person]?
    var parentOf: [GraphQL_Person]?
    var childOf: [GraphQL_Person]?
    var knows: [GraphQL_Person]?
    var verses: [GraphQL_Verse]?
    var verseCount: Int?
    
    init() {
        
    }
    
    enum Gender {
        case male
        case female
        case unknown
    }
}

