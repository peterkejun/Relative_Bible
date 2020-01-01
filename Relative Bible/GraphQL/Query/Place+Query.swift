//
//  Place+Query.swift
//  Theographic
//
//  Created by Jun Ke on 8/1/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

extension GraphQL_Place {
    
    static func placeInfo(id: String, _ completionHandler: @escaping ((Bool, GraphQL_Place) -> Void)) {
        guard let queryURL = Bundle.main.url(forResource: "PlaceQuery", withExtension: "txt"), let query = try? String.init(contentsOf: queryURL) else {
            completionHandler(false, GraphQL_Place.init())
            return
        }
        let variables = "{\"id\": \"\(id)\"}"
        let headers = ["content-type": "application/json"]
        let parameters = ["query": query, "variables": variables] as [String: Any]
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        if postData == nil {
            completionHandler(false, GraphQL_Place.init())
            print("post data is nil")
        }
        let request = NSMutableURLRequest.init(url: URL.init(string: "https://theographic-api.robertrouse.now.sh/")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                completionHandler(false, GraphQL_Place.init())
                print(error as Any)
                return
            } else {
                let json = try! JSONSerialization.jsonObject(with: data!, options: [])
                if let dictionary = json as? [String: Any],
                    let dataDict = dictionary["data"] as? [String: Any],
                    let placeDict = (dataDict["Place"] as? [[String: Any]])?.first {
                    let place = GraphQL_Place.init()
                    place.id = placeDict["id"] as? String
                    place.longitude = placeDict["longitude"] as? Double
                    place.latitude = placeDict["latitude"] as? Double
                    place.name = placeDict["name"] as? String
                    place.alsoCalled = placeDict["alsoCalled"] as? [String]
                    place.featureType = placeDict["featureType"] as? String
                    place.precision = placeDict["precision"] as? String
                    place.description = placeDict["description"] as? String
                    place.source = placeDict["source"] as? String
                    place.comments = placeDict["comment"] as? String
                    completionHandler(true, place)
                    return
                }
                completionHandler(false, GraphQL_Place.init())
                print("casting failed")
            }
        }
        dataTask.resume()
    }
    
    static func placesInBook(osisRef: String, _ completionHandler: @escaping ((Bool, [GraphQL_Place]) -> Void)) {
        guard let queryURL = Bundle.main.url(forResource: "PlacesQuery", withExtension: "txt"), let query = try? String.init(contentsOf: queryURL) else {
            completionHandler(false, [])
            return
        }
        let variables = "{\"osisRef\": \"\(osisRef)\"}"
        let headers = ["content-type": "application/json"]
        let parameters = ["query": query, "variables": variables] as [String: Any]
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        if postData == nil {
            completionHandler(false, [])
            print("post data is nil")
        }
        let request = NSMutableURLRequest.init(url: URL.init(string: "https://theographic-api.robertrouse.now.sh/")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                completionHandler(false, [])
                print(error as Any)
                return
            } else {
                let json = try! JSONSerialization.jsonObject(with: data!, options: [])
                if let dictionary = json as? [String: Any],
                    let dataDict = dictionary["data"] as? [String: Any],
                    let placeArray = dataDict["Place"] as? [[String: Any]] {
                    var places: [GraphQL_Place] = []
                    for placeDict in placeArray {
                        let place = GraphQL_Place.init()
                        place.id = placeDict["id"] as? String
                        place.longitude = placeDict["longitude"] as? Double
                        place.latitude = placeDict["latitude"] as? Double
                        place.name = placeDict["name"] as? String
                        place.alsoCalled = placeDict["alsoCalled"] as? [String]
                        place.featureType = placeDict["featureType"] as? String
                        place.precision = placeDict["precision"] as? String
                        place.description = placeDict["description"] as? String
                        place.source = placeDict["source"] as? String
                        place.comments = placeDict["comment"] as? String
                        places.append(place)
                    }
                    completionHandler(true, places)
                    return
                }
                completionHandler(false, [])
                print("casting failed")
            }
        }
        dataTask.resume()
    }
    
}

