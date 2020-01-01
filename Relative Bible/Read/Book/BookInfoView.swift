//
//  BookInfoScrollView.swift
//  Bible
//
//  Created by Jun Ke on 8/3/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class BookInfoView: UIView {
    
    var book: String = "Genesis"
    var writers: [GraphQL_Person] = []
    
    private(set) var infoScrollView: UIScrollView!
    private(set) var infoBasicTableView: StaticTableView!
    private(set) var placesScrollView: LocationBriefScrollView!
    private(set) var peopleScrollView: PersonBriefScrollView!
    private(set) var briefLabel: UILabel!
    private(set) var briefAttributes: [NSAttributedString.Key : Any] = [:]
    
    init(frame: CGRect, book: String) {
        super.init(frame: frame)
        self.book = book
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
        
        let basicLabel = UILabel.init()
        basicLabel.text = "BASIC"
        basicLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        basicLabel.textColor = UIColor.init(hex: "3C3C43").withAlphaComponent(0.6)
        infoScrollView.addSubview(basicLabel)
        basicLabel.translatesAutoresizingMaskIntoConstraints = false
        basicLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        basicLabel.topAnchor.constraint(equalTo: infoScrollView.topAnchor).isActive = true
        
        infoBasicTableView = StaticTableView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 3 * StaticTableView.standardRowHeight), count: 3, delegate: self)
        infoScrollView.addSubview(infoBasicTableView)
        infoBasicTableView.translatesAutoresizingMaskIntoConstraints = false
        infoBasicTableView.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor).isActive = true
        infoBasicTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        infoBasicTableView.topAnchor.constraint(equalTo: basicLabel.bottomAnchor, constant: 5).isActive = true
        infoBasicTableView.heightAnchor.constraint(equalToConstant: infoBasicTableView.bounds.height).isActive = true
        
        let placesLabel = UILabel.init()
        placesLabel.text = "PLACES"
        placesLabel.textColor = UIColor.init(hex: "3C3C43").withAlphaComponent(0.6)
        placesLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        infoScrollView.addSubview(placesLabel)
        placesLabel.translatesAutoresizingMaskIntoConstraints = false
        placesLabel.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor, constant: 16).isActive = true
        placesLabel.topAnchor.constraint(equalTo: infoBasicTableView.bottomAnchor, constant: 14).isActive = true
        
        let placesSeperatorTop = UIView.init()
        placesSeperatorTop.backgroundColor = UIColor.init(hex: "D0D0D6")
        infoScrollView.addSubview(placesSeperatorTop)
        placesSeperatorTop.translatesAutoresizingMaskIntoConstraints = false
        placesSeperatorTop.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor).isActive = true
        placesSeperatorTop.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        placesSeperatorTop.topAnchor.constraint(equalTo: placesLabel.bottomAnchor, constant: 5).isActive = true
        placesSeperatorTop.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        placesScrollView = LocationBriefScrollView.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: LocationBriefScrollView.standardSize.height + 2 * LocationBriefScrollView.verticalMargin))
        placesScrollView.showActivityIndicator(style: .gray)
        placesScrollView.isUserInteractionEnabled = false
        infoScrollView.addSubview(placesScrollView)
        placesScrollView.translatesAutoresizingMaskIntoConstraints = false
        placesScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        placesScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        placesScrollView.topAnchor.constraint(equalTo: placesSeperatorTop.bottomAnchor).isActive = true
        placesScrollView.heightAnchor.constraint(equalToConstant: placesScrollView.bounds.height).isActive = true
        
        let peopleLabel = UILabel.init()
        peopleLabel.text = "PEOPLE"
        peopleLabel.textColor = UIColor.init(hex: "3C3C43").withAlphaComponent(0.6)
        peopleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        infoScrollView.addSubview(peopleLabel)
        peopleLabel.translatesAutoresizingMaskIntoConstraints = false
        peopleLabel.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor, constant: 16).isActive = true
        peopleLabel.topAnchor.constraint(equalTo: placesScrollView.bottomAnchor, constant: 14).isActive = true
        
        let peopleSeperatorTop = UIView.init()
        peopleSeperatorTop.backgroundColor = UIColor.init(hex: "D0D0D6")
        infoScrollView.addSubview(peopleSeperatorTop)
        peopleSeperatorTop.translatesAutoresizingMaskIntoConstraints = false
        peopleSeperatorTop.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor).isActive = true
        peopleSeperatorTop.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        peopleSeperatorTop.topAnchor.constraint(equalTo: peopleLabel.bottomAnchor, constant: 5).isActive = true
        peopleSeperatorTop.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        peopleScrollView = PersonBriefScrollView.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: PersonBriefScrollView.standardSize.height + 2 * PersonBriefScrollView.verticalMargin))
        peopleScrollView.showActivityIndicator(style: .gray)
        peopleScrollView.isUserInteractionEnabled = false
        infoScrollView.addSubview(peopleScrollView)
        peopleScrollView.translatesAutoresizingMaskIntoConstraints = false
        peopleScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        peopleScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        peopleScrollView.topAnchor.constraint(equalTo: peopleSeperatorTop.bottomAnchor).isActive = true
        peopleScrollView.heightAnchor.constraint(equalToConstant: peopleScrollView.bounds.height).isActive = true
        
        let briefSeperator = UIView.init()
        briefSeperator.backgroundColor = UIColor.init(hex: "DCDCE1")
        briefSeperator.layer.cornerRadius = 0.5
        infoScrollView.addSubview(briefSeperator)
        briefSeperator.translatesAutoresizingMaskIntoConstraints = false
        briefSeperator.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor, constant: 32).isActive = true
        briefSeperator.topAnchor.constraint(equalTo: peopleScrollView.bottomAnchor, constant: 5).isActive = true
        briefSeperator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true
        briefSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        briefLabel = UILabel.init()
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.firstLineHeadIndent = 34
        paragraphStyle.lineSpacing = 12
        paragraphStyle.paragraphSpacing = 15
        briefAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .light),
            NSAttributedString.Key.paragraphStyle : paragraphStyle,
            NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.7)
        ]
        briefLabel.attributedText = NSAttributedString.init(string: BibleData.brief(osisRef: BibleData.bookOsisRefs[book] ?? "Gen") ?? "Not Found", attributes: briefAttributes)
        briefLabel.numberOfLines = 0
        infoScrollView.addSubview(briefLabel)
        briefLabel.translatesAutoresizingMaskIntoConstraints = false
        briefLabel.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor, constant: 35).isActive = true
        briefLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -35).isActive = true
        briefLabel.topAnchor.constraint(equalTo: briefSeperator.bottomAnchor, constant: 20).isActive = true
        
        self.layoutIfNeeded()
        infoScrollView.contentSize = CGSize.init(width: infoScrollView.bounds.width, height: briefLabel.frame.maxY + 10)
    }
    
    func fetchAndUpdate() {
        guard let osisRef = BibleData.bookOsisRefs[book] else { return }
        GraphQL_Place.placesInBook(osisRef: osisRef) { (valid, places) in
            if valid {
                DispatchQueue.main.async {
                    var visiblePlaces: [GraphQL_Place] = []
                    for n in 0..<(6 <= places.count ? 6 : places.count) {
                        visiblePlaces.append(places[n])
                    }
                    self.placesScrollView.setLocations(visiblePlaces)
                    self.placesScrollView.removeActivityIndicator()
                    self.placesScrollView.isUserInteractionEnabled = true
                }
            }
        }
        GraphQL_Person.peopleInBook(osisRef: osisRef) { (valid, people) in
            if valid {
                DispatchQueue.main.async {
                    var visiblePeople: [GraphQL_Person] = []
                    for n in 0..<(6 <= people.count ? 6 : people.count) {
                        visiblePeople.append(people[n])
                    }
                    self.peopleScrollView.setPeople(visiblePeople)
                    self.peopleScrollView.removeActivityIndicator()
                    self.peopleScrollView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
}

extension BookInfoView: StaticTableViewDelegate {
    func staticTableView(_ staticTableView: StaticTableView, populateView view: UIView, ofIndex index: Int) {
        let primaryLabel = UILabel.init()
        primaryLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let secondaryLabel = UILabel.init()
        secondaryLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        if index == 0 {
            primaryLabel.text = "Number of chapters:"
            secondaryLabel.text = "\(BibleData.numChaptersDict[book] ?? 0)"
        } else if index == 1 {
            if writers.isEmpty == false {
                primaryLabel.text = "Writer:"
                var writersText = ""
                for (n, name) in writers.compactMap({ $0.name }).enumerated() {
                    writersText.append(name)
                    if n != writers.count - 1 {
                        writersText.append(", ")
                    }
                }
                secondaryLabel.text = writersText
            } else {
                view.showActivityIndicator(style: .gray)
                primaryLabel.text = ""
                secondaryLabel.text = ""
            }
        } else {
            primaryLabel.text = "Division:"
            secondaryLabel.text = BibleData.division(book: book) ?? "Not Found"
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

