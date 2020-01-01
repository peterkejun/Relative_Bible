//
//  Vertex.swift
//  BiblicalPersonsGraph
//
//  Created by Jun Ke on 8/8/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

public struct Vertex<T: Hashable> {
    var data: T
}

extension Vertex: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(data)".hashValue)
    }
    
    static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.data == rhs.data
    }
}

extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(data)"
    }
}

