//
//  Person+Query.swift
//  Bible
//
//  Created by Jun Ke on 8/2/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

extension GraphQL_Person {
    
    static func personInfo(id: String, _ completionHandler: @escaping ((Bool, GraphQL_Person) -> Void)) {
        guard let queryURL = Bundle.main.url(forResource: "WriterQuery", withExtension: "txt"), let query = try? String.init(contentsOf: queryURL) else {
            completionHandler(false, GraphQL_Person.init())
            return
        }
        let variables = "{\"id\": \"\(id)\"}"
        let headers = ["content-type": "application/json"]
        let parameters = ["query": query, "variables": variables] as [String: Any]
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        if postData == nil {
            completionHandler(false, GraphQL_Person.init())
            print("post data is nil")
        }
        let request = NSMutableURLRequest.init(url: URL.init(string: "https://theographic-api.robertrouse.now.sh/")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                completionHandler(false, GraphQL_Person.init())
                print(error as Any)
                return
            } else {
                let json = try! JSONSerialization.jsonObject(with: data!, options: [])
                if let dictionary = json as? [String: Any],
                    let dataDict = dictionary["data"] as? [String: Any],
                    let peopleArray = dataDict["Person"] as? [[String: Any]],
                    let personDict = peopleArray.first {
                    let person = GraphQL_Person.init()
                    //id
                    person.id = personDict["id"] as? String
                    //name
                    person.name = personDict["name"] as? String
                    //also called
                    person.alsoCalled = personDict["alsoCalled"] as? [String]
                    //gender
                    if let gender = personDict["gender"] as? String {
                        if gender == "Male" { person.gender = .male }
                        else if gender == "Female" { person.gender = .female }
                        else { person.gender = .unknown }
                    } else {
                        person.gender = nil
                    }
                    //description
                    person.description = personDict["description"] as? String
                    //birth year
                    if let birthYearDict = (personDict["birthYear"] as? [[String: Any]])?.first,
                        let birthYear = birthYearDict["year"] as? Int,
                        let birthYearFormatted = birthYearDict["formattedYear"] as? String {
                        let year = GraphQL_Year.init()
                        year.year = birthYear
                        year.formattedYear = birthYearFormatted
                        person.birthYear = [year]
                    }
                    //death year
                    if let deathYearDict = (personDict["deathYear"] as? [[String: Any]])?.first,
                        let deathYear = deathYearDict["year"] as? Int,
                        let deathYearFormatted = deathYearDict["formattedYear"] as? String {
                        let year = GraphQL_Year.init()
                        year.year = deathYear
                        year.formattedYear = deathYearFormatted
                        person.birthYear = [year]
                    }
                    //birth place
                    if let birthPlaceDict = (personDict["birthPlace"] as? [[String: Any]])?.first,
                        let placeID = birthPlaceDict["id"] as? String,
                        let placeName = birthPlaceDict["name"] as? String {
                        let place = GraphQL_Place.init()
                        place.id = placeID
                        place.name = placeName
                        place.latitude = birthPlaceDict["latitude"] as? Double
                        place.longitude = birthPlaceDict["longitude"] as? Double
                        person.birthPlace = [place]
                    }
                    //death place
                    if let deathPlaceDict = (personDict["deathPlace"] as? [[String: Any]])?.first,
                        let placeID = deathPlaceDict["id"] as? String,
                        let placeName = deathPlaceDict["name"] as? String {
                        let place = GraphQL_Place.init()
                        place.id = placeID
                        place.name = placeName
                        place.latitude = deathPlaceDict["latitude"] as? Double
                        place.longitude = deathPlaceDict["longitude"] as? Double
                        person.deathPlace = [place]
                    }
                    //member of
                    if let groupArray = personDict["memberOf"] as? [[String: Any]] {
                        var groups: [GraphQL_PeopleGroup] = []
                        for groupDict in groupArray {
                            let group = GraphQL_PeopleGroup.init()
                            group.id = groupDict["id"] as? String
                            group.name = groupDict["name"] as? String
                            groups.append(group)
                        }
                        person.memberOf = groups
                    }
                    //writer of
                    if let bookArray = personDict["writerOf"] as? [[String: Any]] {
                        var books: [GraphQL_Book] = []
                        for bookDict in bookArray {
                            let book = GraphQL_Book.init()
                            book.id = bookDict["id"] as? String
                            book.title = bookDict["title"] as? String
                            if let writerArray = bookDict["writers"] as? [[String: Any]] {
                                var writers: [GraphQL_Person] = []
                                for writerDict in writerArray {
                                    let writer = GraphQL_Person.init()
                                    writer.id = writerDict["id"] as? String
                                    writer.name = writerDict["name"] as? String
                                    writers.append(writer)
                                }
                                book.writers = writers
                            }
                            books.append(book)
                        }
                        person.writerOf = books
                    }
                    //has been to
                    if let placeArray = personDict["hasBeenTo"] as? [[String: Any]] {
                        var places: [GraphQL_Place] = []
                        for placeDict in placeArray {
                            let place = GraphQL_Place.init()
                            place.id = placeDict["id"] as? String
                            place.name = placeDict["name"] as? String
                            place.latitude = placeDict["latitude"] as? Double
                            place.longitude = placeDict["longitude"] as? Double
                            places.append(place)
                        }
                        person.hasBeenTo = places
                    }
                    //parent of
                    if let childArray = personDict["parentOf"] as? [[String: Any]] {
                        var children: [GraphQL_Person] = []
                        for childDict in childArray {
                            let child = GraphQL_Person.init()
                            child.id = childDict["id"] as? String
                            child.name = childDict["name"] as? String
                            children.append(child)
                        }
                        person.parentOf = children
                    }
                    //partner of
                    if let partnerArray = personDict["partnerOf"] as? [[String: Any]] {
                        var partners: [GraphQL_Person] = []
                        for partnerDict in partnerArray {
                            let partner = GraphQL_Person.init()
                            partner.id = partnerDict["id"] as? String
                            partner.name = partnerDict["name"] as? String
                            partners.append(partner)
                        }
                        person.partnerOf = partners
                    }
                    //child of
                    if let parentArray = personDict["childOf"] as? [[String: Any]] {
                        var parents: [GraphQL_Person] = []
                        for parentDict in parentArray {
                            let parent = GraphQL_Person.init()
                            parent.id = parentDict["id"] as? String
                            parent.name = parentDict["name"] as? String
                            parents.append(parent)
                        }
                        person.childOf = parents
                    }
                    //knows
                    if let knowArray = personDict["knows"] as? [[String: Any]] {
                        var knows: [GraphQL_Person] = []
                        for knowDict in knowArray {
                            let know = GraphQL_Person.init()
                            know.id = knowDict["id"] as? String
                            know.name = knowDict["name"] as? String
                            knows.append(know)
                        }
                        person.knows = knows
                    }
                    //verses
                    if let versesArray = personDict["verses"] as? [[String: Any]] {
                        var verses: [GraphQL_Verse] = []
                        for verseDict in versesArray {
                            if let osisRef = verseDict["osisRef"] as? String {
                                let verse = GraphQL_Verse.init()
                                verse.osisRef = osisRef
                                verses.append(verse)
                            }
                        }
                        person.verses = verses
                    }
                    completionHandler(true, person)
                    return
                }
                completionHandler(false, GraphQL_Person.init())
                print("casting failed")
            }
        }
        dataTask.resume()
    }
    
    static func peopleInBook(osisRef: String, _ completionHandler: @escaping ((Bool, [GraphQL_Person]) -> Void)) {
        guard let queryURL = Bundle.main.url(forResource: "PeopleQuery", withExtension: "txt"), let query = try? String.init(contentsOf: queryURL) else {
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
                    let peopleArray = dataDict["Person"] as? [[String: Any]] {
                    var people: [GraphQL_Person] = []
                    for personDict in peopleArray {
                        let person = GraphQL_Person.init()
                        person.id = personDict["id"] as? String
                        person.name = personDict["name"] as? String
                        person.alsoCalled = personDict["alsoCalled"] as? [String]
                        if let gender = personDict["gender"] as? String {
                            if gender == "Male" { person.gender = .male }
                            else if gender == "Female" { person.gender = .female }
                            else { person.gender = .unknown }
                        } else {
                            person.gender = nil
                        }
                        person.description = personDict["description"] as? String
                        if let birthYearDict = (personDict["birthYear"] as? [[String: Any]])?.first,
                            let birthYear = birthYearDict["year"] as? Int,
                            let birthYearFormatted = birthYearDict["formattedYear"] as? String {
                            let year = GraphQL_Year.init()
                            year.year = birthYear
                            year.formattedYear = birthYearFormatted
                            person.birthYear = [year]
                        }
                        if let deathYearDict = (personDict["deathYear"] as? [[String: Any]])?.first,
                            let deathYear = deathYearDict["year"] as? Int,
                            let deathYearFormatted = deathYearDict["formattedYear"] as? String {
                            let year = GraphQL_Year.init()
                            year.year = deathYear
                            year.formattedYear = deathYearFormatted
                            person.birthYear = [year]
                        }
                        if let versesArray = personDict["verses"] as? [[String: Any]] {
                            var verses: [GraphQL_Verse] = []
                            for verseDict in versesArray {
                                if let osisRef = verseDict["osisRef"] as? String {
                                    let verse = GraphQL_Verse.init()
                                    verse.osisRef = osisRef
                                    verses.append(verse)
                                }
                            }
                            person.verses = verses
                        }
                        people.append(person)
                    }
                    completionHandler(true, people)
                    return
                }
                completionHandler(false, [])
                print("casting failed")
            }
        }
        dataTask.resume()
    }
    
}

