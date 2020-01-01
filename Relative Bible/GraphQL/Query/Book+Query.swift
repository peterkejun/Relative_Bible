//
//  Book+Query.swift
//  Bible
//
//  Created by Jun Ke on 8/3/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

extension GraphQL_Book {
    
    static func findWriters(osisRef: String, _ completionHandler: @escaping ((Bool, [GraphQL_Person]) -> Void)) {
        guard let queryURL = Bundle.main.url(forResource: "BookFindWritersQuery", withExtension: "txt"), let query = try? String.init(contentsOf: queryURL) else {
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
                    let bookArray = dataDict["Book"] as? [[String: Any]],
                    let bookDict = bookArray.first,
                    let writersArray = bookDict["writers"] as? [[String: Any]] {
                    var writers: [GraphQL_Person] = []
                    for writersDict in writersArray {
                        let person = GraphQL_Person.init()
                        person.id = writersDict["id"] as? String
                        person.name = writersDict["name"] as? String
                        writers.append(person)
                    }
                    completionHandler(true, writers)
                    return
                }
                completionHandler(false, [])
                print("casting failed")
            }
        }
        dataTask.resume()
    }
    
}

