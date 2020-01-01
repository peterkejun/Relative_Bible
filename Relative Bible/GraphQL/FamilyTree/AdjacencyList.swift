//
//  AdjacencyList.swift
//  BiblicalPersonsGraph
//
//  Created by Jun Ke on 8/8/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

open class AdjacencyList<T: Hashable> {
    public var adjacencyDict: [Vertex<T>: [Edge<T>]] = [:]
    public init() {}
    
    fileprivate func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, relationship: Relationship?) {
        let edge = Edge(source: source, destination: destination, relationship: relationship) // 1
        adjacencyDict[source]?.append(edge) // 2
    }
    
    fileprivate func addUndirectedEdge(vertices: (Vertex<Element>, Vertex<Element>), relationship: Relationship?) {
        let (source, destination) = vertices
        addDirectedEdge(from: source, to: destination, relationship: relationship)
        addDirectedEdge(from: destination, to: source, relationship: relationship)
    }
}

extension AdjacencyList: Graphable {
    public typealias Element = T
    
    func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(data: data)
        if adjacencyDict[vertex] == nil {
            adjacencyDict[vertex] = []
        }
        return vertex
    }
    
    func add(_ type: EdgeType, from source: Vertex<T>, to destination: Vertex<T>, relationship: Relationship) {
        switch type {
        case .directed:
            addDirectedEdge(from: source, to: destination, relationship: relationship)
        default:
            addUndirectedEdge(vertices: (source, destination), relationship: relationship)
        }
    }
    
    func relationship(between source: Vertex<T>, and destination: Vertex<T>) -> Relationship? {
        guard let edges = adjacencyDict[source] else {
            return nil
        }
        for edge in edges {
            if edge.destination == destination {
                return edge.relationship
            }
        }
        return nil
    }
    
    func edges(from source: Vertex<T>) -> [Edge<T>]? {
        return adjacencyDict[source]
    }
    
    var description: CustomStringConvertible {
        var result = ""
        for (vertex, edges) in adjacencyDict {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ] \n ")
        }
        return result
    }
    
    var numVertex: Int {
        return adjacencyDict.count
    }
}

