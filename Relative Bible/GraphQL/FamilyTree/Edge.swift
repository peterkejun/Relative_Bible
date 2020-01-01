//
//  Edge.swift
//  BiblicalPersonsGraph
//
//  Created by Jun Ke on 8/8/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

public enum EdgeType {
    case directed, undirected
}

public struct Edge<T: Hashable> {
    public var source: Vertex<T>
    public var destination: Vertex<T>
    public var relationship: Relationship?
}

extension Edge: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(source)\(destination)\(relationship)".hashValue)
    }
    static public func ==(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
        return lhs.source == rhs.source &&
            lhs.destination == rhs.destination &&
            lhs.relationship == rhs.relationship
    }
}

