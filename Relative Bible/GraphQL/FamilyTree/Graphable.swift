//
//  Graphable.swift
//  BiblicalPersonsGraph
//
//  Created by Jun Ke on 8/8/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

protocol Graphable {
    associatedtype Element: Hashable
    var description: CustomStringConvertible { get }
    func createVertex(data: Element) -> Vertex<Element>
    func add(_ type: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, relationship: Relationship)
    func relationship(between source: Vertex<Element>, and destination: Vertex<Element>) -> Relationship?
    func edges(from source: Vertex<Element>) -> [Edge<Element>]?
    var numVertex: Int { get }
}

