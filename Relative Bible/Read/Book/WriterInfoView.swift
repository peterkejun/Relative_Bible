//
//  WriterInfoView.swift
//  Bible
//
//  Created by Jun Ke on 8/3/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class WriterInfoView: UIView {
    
    var writerID: String = "recjNRR60PAuFtjha"
    
    var nameLabel: UILabel!
    var infoScrollView: UIScrollView!
    var infoBasicTableView: StaticTableView!
    var birthDeathLabel: UILabel!
    var birthDeathPlaceScrollView: LocationBriefScrollView!
    var bookScrollView: BookBriefScrollView!
    var briefLabel: UILabel!
    var briefAttributes: [NSAttributedString.Key : Any] = [:]
    var gender: String = "Male"
    var memberOf: String = "Tribe of Levi"
    
    init(frame: CGRect, writerID: String) {
        super.init(frame: frame)
        self.writerID = writerID
        initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        self.backgroundColor = UIColor.init(white: 1, alpha: 0)
        
        infoScrollView = UIScrollView.init()
        infoScrollView.backgroundColor = UIColor.init(white: 1, alpha: 0)
        self.addSubview(infoScrollView)
        infoScrollView.translatesAutoresizingMaskIntoConstraints = false
        infoScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        infoScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        infoScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        infoScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        nameLabel = UILabel.init()
        nameLabel.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        nameLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
        nameLabel.text = " "
        infoScrollView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: infoScrollView.topAnchor).isActive = true
        
        let basicLabel = UILabel.init()
        basicLabel.text = "BASIC"
        basicLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        basicLabel.textColor = UIColor.init(hex: "3C3C43").withAlphaComponent(0.6)
        infoScrollView.addSubview(basicLabel)
        basicLabel.translatesAutoresizingMaskIntoConstraints = false
        basicLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        basicLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        
        infoBasicTableView = StaticTableView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2 * StaticTableView.standardRowHeight), count: 2, delegate: self)
        infoScrollView.addSubview(infoBasicTableView)
        infoBasicTableView.translatesAutoresizingMaskIntoConstraints = false
        infoBasicTableView.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor).isActive = true
        infoBasicTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        infoBasicTableView.topAnchor.constraint(equalTo: basicLabel.bottomAnchor, constant: 5).isActive = true
        infoBasicTableView.heightAnchor.constraint(equalToConstant: infoBasicTableView.bounds.height).isActive = true
        
        birthDeathLabel = UILabel.init()
        birthDeathLabel.text = "Birth (1571 BC) & Death (1451 BC)"
        birthDeathLabel.textColor = UIColor.init(hex: "3C3C43").withAlphaComponent(0.6)
        birthDeathLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        infoScrollView.addSubview(birthDeathLabel)
        birthDeathLabel.translatesAutoresizingMaskIntoConstraints = false
        birthDeathLabel.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor, constant: 16).isActive = true
        birthDeathLabel.topAnchor.constraint(equalTo: infoBasicTableView.bottomAnchor, constant: 14).isActive = true
        
        let birthDeathSeperatorTop = UIView.init()
        birthDeathSeperatorTop.backgroundColor = UIColor.init(hex: "D0D0D6")
        infoScrollView.addSubview(birthDeathSeperatorTop)
        birthDeathSeperatorTop.translatesAutoresizingMaskIntoConstraints = false
        birthDeathSeperatorTop.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor).isActive = true
        birthDeathSeperatorTop.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        birthDeathSeperatorTop.topAnchor.constraint(equalTo: birthDeathLabel.bottomAnchor, constant: 5).isActive = true
        birthDeathSeperatorTop.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        birthDeathPlaceScrollView = LocationBriefScrollView.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: LocationBriefScrollView.standardSize.height + 2 * LocationBriefScrollView.verticalMargin))
        birthDeathPlaceScrollView.showActivityIndicator(style: .gray)
        birthDeathPlaceScrollView.isUserInteractionEnabled = false
        infoScrollView.addSubview(birthDeathPlaceScrollView)
        birthDeathPlaceScrollView.translatesAutoresizingMaskIntoConstraints = false
        birthDeathPlaceScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        birthDeathPlaceScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        birthDeathPlaceScrollView.topAnchor.constraint(equalTo: birthDeathSeperatorTop.bottomAnchor).isActive = true
        birthDeathPlaceScrollView.heightAnchor.constraint(equalToConstant: birthDeathPlaceScrollView.bounds.height).isActive = true
        
        let writerOfLabel = UILabel.init()
        writerOfLabel.text = "WRITER OF"
        writerOfLabel.textColor = UIColor.init(hex: "3C3C43").withAlphaComponent(0.6)
        writerOfLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        infoScrollView.addSubview(writerOfLabel)
        writerOfLabel.translatesAutoresizingMaskIntoConstraints = false
        writerOfLabel.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor, constant: 16).isActive = true
        writerOfLabel.topAnchor.constraint(equalTo: birthDeathPlaceScrollView.bottomAnchor, constant: 14).isActive = true
        
        let writerOfSeperatorTop = UIView.init()
        writerOfSeperatorTop.backgroundColor = UIColor.init(hex: "D0D0D6")
        infoScrollView.addSubview(writerOfSeperatorTop)
        writerOfSeperatorTop.translatesAutoresizingMaskIntoConstraints = false
        writerOfSeperatorTop.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor).isActive = true
        writerOfSeperatorTop.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        writerOfSeperatorTop.topAnchor.constraint(equalTo: writerOfLabel.bottomAnchor, constant: 5).isActive = true
        writerOfSeperatorTop.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        bookScrollView = BookBriefScrollView.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: BookBriefScrollView.standardSize.height + 2 * BookBriefScrollView.verticalMargin))
        bookScrollView.showActivityIndicator(style: .gray)
        bookScrollView.isUserInteractionEnabled = false
        infoScrollView.addSubview(bookScrollView)
        bookScrollView.translatesAutoresizingMaskIntoConstraints = false
        bookScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bookScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bookScrollView.topAnchor.constraint(equalTo: writerOfSeperatorTop.bottomAnchor).isActive = true
        bookScrollView.heightAnchor.constraint(equalToConstant: bookScrollView.bounds.height).isActive = true
        
        self.layoutIfNeeded()
        infoScrollView.contentSize = CGSize.init(width: infoScrollView.bounds.width, height: bookScrollView.frame.maxY)
    }
    
    func fetchAndUpdate() {
        GraphQL_Person.personInfo(id: writerID) { (valid, person) in
            if valid {
                DispatchQueue.main.async {
                    if let name = person.name {
                        self.nameLabel.text = name
                    }
                    if let formattedBirthYear = person.birthYear?.first?.formattedYear, let formattedDeathYear = person.deathYear?.first?.formattedYear {
                        self.birthDeathLabel.text = "Birth (\(formattedBirthYear)) & Death (\(formattedDeathYear))"
                    }
                    if let birthPlaceID = person.birthPlace?.first?.id, let deathPlaceID = person.deathPlace?.first?.id {
                        GraphQL_Place.placeInfo(id: birthPlaceID, { (validBirth, birthPlace) in
                            GraphQL_Place.placeInfo(id: deathPlaceID, { (validDeath, deathPlace) in
                                DispatchQueue.main.async {
                                    self.birthDeathPlaceScrollView.setLocations([birthPlace, deathPlace])
                                    self.birthDeathPlaceScrollView.removeActivityIndicator()
                                    self.birthDeathPlaceScrollView.isUserInteractionEnabled = true
                                }
                            })
                        })
                    }
                    if let books = person.writerOf {
                        self.bookScrollView.setBooks(books)
                        self.bookScrollView.removeActivityIndicator()
                        self.bookScrollView.isUserInteractionEnabled = true
                    }
                    if let gender = person.gender {
                        if gender == .male {
                            self.gender = "Male"
                        } else if gender == .female {
                            self.gender = "Female"
                        } else {
                            self.gender = "Unknown"
                        }
                    } else {
                        self.gender = "Unknown"
                    }
                    if let memberOf = person.memberOf?.first {
                        self.memberOf = memberOf.name ?? "Not Found"
                    }
                    self.infoBasicTableView.reload()
                }
            }
        }
    }
    
}

extension WriterInfoView: StaticTableViewDelegate {
    func staticTableView(_ staticTableView: StaticTableView, populateView view: UIView, ofIndex index: Int) {
        let primaryLabel = UILabel.init()
        primaryLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let secondaryLabel = UILabel.init()
        secondaryLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        if index == 0 {
            primaryLabel.text = "Gender"
            secondaryLabel.text = gender
        } else if index == 1 {
            primaryLabel.text = "Member of:"
            secondaryLabel.text = memberOf
        }
        view.addSubview(primaryLabel)
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        primaryLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(secondaryLabel)
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        secondaryLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

