//
//  FamilyTree.swift
//  Bible
//
//  Created by Jun Ke on 8/8/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

class FamilyTree {
    
    private(set) var isReady: Bool = false
    
    private let adjacencyList = AdjacencyList<Int>()
    
    init() {
        self.isReady = self.loadData()
    }
    
    func firstLevelRelatives(of id: Int) -> [Int] {
        let source = Vertex<Int>.init(data: id)
        guard let edges = self.adjacencyList.edges(from: source) else {
            return []
        }
        return edges.map { $0.destination.data }
    }
    
    func relativesOf(id: Int, withRelationship relationship: Relationship) -> [Int] {
        let src = Vertex<Int>.init(data: id)
        guard let edges = self.adjacencyList.edges(from: src) else { return [] }
        return edges.filter({ $0.relationship == relationship }).map({ $0.destination.data })
    }
    
    func relationship(between id1: Int, and id2: Int) -> Relationship? {
        let c1 = Vertex<Int>.init(data: id1)
        guard let edges = self.adjacencyList.edges(from: c1) else { return nil }
        for e in edges {
            if e.destination.data == id2 {
                return e.relationship
            }
        }
        return nil
    }
    
    func typesOfRelationships(of id: Int) -> [Relationship] {
        let src = Vertex<Int>.init(data: id)
        guard let edges = self.adjacencyList.edges(from: src) else { return [] }
        return Array(Set(edges.map({ $0.relationship }).compactMap({ $0 })))
    }
    
    func compactGraph(root id: Int) -> AdjacencyList<Int> {
        let source = Vertex<Int>.init(data: id)
        var reachables = self.DFS(source: source)
        reachables.append(source)
        let compactAdjList = AdjacencyList<Int>()
        _ = reachables.map { compactAdjList.createVertex(data: $0.data) }
        for vertex in reachables {
            guard let edges = self.adjacencyList.edges(from: vertex) else { continue }
            for (destination, relationship) in (edges.map { ($0.destination, $0.relationship) }) {
                if reachables.contains(destination) && relationship != nil {
                    compactAdjList.add(.directed, from: vertex, to: destination, relationship: relationship!)
                }
            }
        }
        return compactAdjList
    }
    
}

// MARK: - Depth First Search

extension FamilyTree {
    
    func DFS(source: Vertex<Int>) -> [Vertex<Int>] {
        var reachableVertex: [Vertex<Int>] = []
        var isVisited: [Int: Bool] = [:]
        for vertex in self.adjacencyList.adjacencyDict.keys {
            isVisited[vertex.data] = false
        }
        self.DFSUtil(vertex: source, visited: &isVisited, reachableArray: &reachableVertex)
        return reachableVertex
    }
    
    fileprivate func DFSUtil(vertex: Vertex<Int>, visited: inout [Int: Bool], reachableArray: inout [Vertex<Int>]) {
        visited[vertex.data] = true
        for adjVertex in self.adjacencyList.adjacencyDict[vertex]!.map({ $0.destination }) {
            if !visited[adjVertex.data]! {
                reachableArray.append(adjVertex)
                DFSUtil(vertex: adjVertex, visited: &visited, reachableArray: &reachableArray)
            }
        }
    }
    
}

// MARK: - Data

extension FamilyTree {
    
    func loadData() -> Bool {
        let ids = BibleData.characterIDs
        for id in ids {
            let connections = BibleData.characterConnections(id: id)
            let src = self.adjacencyList.createVertex(data: id)
            let gender = BibleData.gender(id: id)
            //parent of
            if let parentOf = connections["parentOf"] {
                for child in parentOf {
                    let des = self.adjacencyList.createVertex(data: child)
                    self.adjacencyList.add(.directed, from: src, to: des, relationship: gender == 0 ? Relationship.Father : Relationship.Mother)
                }
            }
            //partner of
            if let partnerOf = connections["partnerOf"] {
                for partner in partnerOf {
                    let des = self.adjacencyList.createVertex(data: partner)
                    self.adjacencyList.add(.directed, from: src, to: des, relationship: .Partner)
                }
            }
            //child of
            if let childOf = connections["childOf"] {
                for parent in childOf {
                    let des = self.adjacencyList.createVertex(data: parent)
                    self.adjacencyList.add(.directed, from: src, to: des, relationship: gender == 0 ? Relationship.Son : Relationship.Daughter)
                }
            }
        }
        print("family tree graph created")
        return true
//        guard let dataURL = Bundle.main.url(forResource: "family_tree", withExtension: "txt"), let data = try? Data.init(contentsOf: dataURL) else {
//            print("Family Tree Load Failed")
//            return false
//        }
//        let jsonDict = (try! JSONSerialization.jsonObject(with: data, options: [])) as! [String: Any]
//        let dataDict = jsonDict["data"] as! [String: Any]
//        let peopleArray = dataDict["Person"] as! [[String: Any]]
//
//        var peopleDict: [String: Vertex<String>] = [:]
//        for personDict in peopleArray {
//            let name = personDict["name"] as! String
//            let person = self.adjacencyList.createVertex(data: name)
//            peopleDict[name] = person
//        }
//
//        for personDict in peopleArray {
//            let name = personDict["name"] as! String
//            let gender = personDict["gender"] as! String
//            let source = peopleDict[name]!
//            //child of
//            let childOfArray = personDict["childOf"] as! [[String: Any]]
//            for parent in childOfArray {
//                let parentName = parent["name"] as! String
//                let parentGender = parent["gender"] as! String
//                let destination = peopleDict[parentName]!
//                self.adjacencyList.add(.directed, from: source, to: destination, relationship: parentGender == "Male" ? Relationship.Child_M : Relationship.Child_F)
//            }
//            //parent of
//            let parentOfArray = personDict["parentOf"] as! [[String: Any]]
//            for child in parentOfArray {
//                let childName = child["name"] as! String
//                let destination = peopleDict[childName]!
//                self.adjacencyList.add(.directed, from: source, to: destination, relationship: gender == "Male" ? Relationship.Father : Relationship.Mother)
//            }
//            //partner of
//            let partnerOfArray = personDict["partnerOf"] as! [[String: Any]]
//            for partner in partnerOfArray {
//                let partnerName = partner["name"] as! String
//                let destination = peopleDict[partnerName]!
//                self.adjacencyList.add(.directed, from: source, to: destination, relationship: .Partner)
//            }
//        }
//        print("Family Tree Load Successful")
//        return true
    }
    
}

