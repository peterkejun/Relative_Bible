//
//  BookVC+Info.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension BookInfoViewController {
    
    func layoutInfo() {
        infoSectionControl = JKSegmentedControl.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width - 32, height: JKSegmentedControl.standardHeight), items: ["Book", "Writer"])
        infoSectionControl.addTarget(self, action: #selector(self.infoControlValueChanged))
        infoView.addSubview(infoSectionControl)
        infoSectionControl.translatesAutoresizingMaskIntoConstraints = false
        infoSectionControl.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 16).isActive = true
        infoSectionControl.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -16).isActive = true
        infoSectionControl.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 11).isActive = true
        infoSectionControl.heightAnchor.constraint(equalToConstant: infoSectionControl.bounds.height).isActive = true
        
        bookInfoView = BookInfoView.init(frame: self.view.bounds, book: book)
        infoView.addSubview(bookInfoView)
        bookInfoView.translatesAutoresizingMaskIntoConstraints = false
        bookInfoViewLeadingConstraint = bookInfoView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor)
        bookInfoViewLeadingConstraint.isActive = true
        bookInfoView.widthAnchor.constraint(equalTo: infoView.widthAnchor).isActive = true
        bookInfoView.topAnchor.constraint(equalTo: infoSectionControl.bottomAnchor, constant: 13).isActive = true
        bookInfoView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
        
        writerInfoView = WriterInfoView.init(frame: self.view.bounds)
        infoView.addSubview(writerInfoView)
        writerInfoView.translatesAutoresizingMaskIntoConstraints = false
        writerInfoView.leadingAnchor.constraint(equalTo: bookInfoView.trailingAnchor).isActive = true
        writerInfoView.widthAnchor.constraint(equalTo: bookInfoView.widthAnchor).isActive = true
        writerInfoView.topAnchor.constraint(equalTo: bookInfoView.topAnchor).isActive = true
        writerInfoView.bottomAnchor.constraint(equalTo: bookInfoView.bottomAnchor).isActive = true
        
        if let osisRef = BibleData.bookOsisRefs[book] {
            GraphQL_Book.findWriters(osisRef: osisRef) { (valid, people) in
                if valid {
                    DispatchQueue.main.async {
                        self.bookInfoView.infoBasicTableView.views[1].removeActivityIndicator()
                        self.bookInfoView.writers = people
                        self.bookInfoView.infoBasicTableView.reload()
                        self.writerInfoView.writerID = people.count == 0 ? "nil" : people.first!.id!
                        self.writerInfoView.fetchAndUpdate()
                    }
                }
            }
        }
    }
    
}

extension BookInfoViewController: StaticTableViewDelegate {
    
    func staticTableView(_ staticTableView: StaticTableView, populateView view: UIView, ofIndex index: Int) {
        let primaryLabel = UILabel.init()
        primaryLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let secondaryLabel = UILabel.init()
        secondaryLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        if index == 0 {
            primaryLabel.text = "Number of chapters:"
            secondaryLabel.text = "\(BibleData.numChaptersDict[book] ?? 0)"
        } else if index == 1 {
            primaryLabel.text = "Writer:"
            secondaryLabel.text = "Moses"
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

