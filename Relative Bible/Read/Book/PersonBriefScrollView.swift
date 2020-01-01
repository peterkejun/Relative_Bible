//
//  PersonBriefScrollView.swift
//  Bible
//
//  Created by Jun Ke on 8/2/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class PersonBriefScrollView: UIScrollView, UIScrollViewDelegate {
    
    static let standardSize: CGSize = .init(width: 198, height: 271)
    static let verticalMargin: CGFloat = 20
    
    private let focusedLeadingMargin: CGFloat = 16
    private let spacing: CGFloat = 13
    
    private(set) var people: [GraphQL_Person] = []
    
    private var views: [UIView] = []
    private var currentFocus: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isScrollEnabled = true
        self.delegate = self
        self.decelerationRate = .fast
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if ((scrollView.contentOffset.x + scrollView.frame.size.width) >= scrollView.contentSize.width) {
            return
        }
        let triggerVelocity: CGFloat = 0.5
        if velocity.x >= triggerVelocity && currentFocus + 1 < views.count {
            currentFocus += 1
            targetContentOffset.pointee.x = CGFloat(currentFocus) * (PersonBriefScrollView.standardSize.width + spacing)
        } else if velocity.x <= -triggerVelocity && currentFocus - 1 >= 0 {
            currentFocus -= 1
            targetContentOffset.pointee.x = CGFloat(currentFocus) * (PersonBriefScrollView.standardSize.width + spacing)
        } else {
            currentFocus = lrintf(Float(targetContentOffset.pointee.x) / Float(PersonBriefScrollView.standardSize.width + spacing))
            targetContentOffset.pointee.x = CGFloat(currentFocus) * (PersonBriefScrollView.standardSize.width + spacing)
        }
    }
    
    func setPeople(_ people: [GraphQL_Person]) {
        if people.count == 0 {
            return
        }
        for view in views {
            view.removeFromSuperview()
        }
        views.removeAll()
        self.people = people
        for person in self.people {
            let view = UIView.init(frame: .init(origin: .zero, size: PersonBriefScrollView.standardSize))
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 15
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = .init(width: 0, height: 2)
            view.layer.shadowRadius = 2
            view.layer.shadowOpacity = 0.5
            
            let imageView = UIImageView.init()
            imageView.image = UIImage.init(named: "ChristTheRedeemerBackground")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            var previousView: UIView? = nil
            
            let nameLabel = UILabel.init()
            nameLabel.text = person.name ?? "Not Found"
            nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            nameLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
            nameLabel.numberOfLines = 0
            view.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 7).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            previousView = nameLabel
            
            let genderLabel = UILabel.init()
            if person.gender == GraphQL_Person.Gender.male {
                genderLabel.text = "MALE"
            } else if person.gender == GraphQL_Person.Gender.female {
                genderLabel.text = "FEMALE"
            } else {
                genderLabel.text = "UNKNOWN"
            }
            genderLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
            genderLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
            view.addSubview(genderLabel)
            genderLabel.translatesAutoresizingMaskIntoConstraints = false
            genderLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
            genderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
            genderLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
            previousView = genderLabel
            
            if let alsoCalled = person.alsoCalled?.first {
                let alsoCalledLabel = UILabel.init()
                let content = NSMutableAttributedString.init(string: "also called: \(alsoCalled)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.7)])
                content.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12, weight: .light).with(.traitItalic), range: NSRange.init(location: 0, length: 12))
                content.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12, weight: .light), range: NSRange.init(location: 13, length: alsoCalled.count))
                alsoCalledLabel.attributedText = content
                alsoCalledLabel.numberOfLines = 0
                view.addSubview(alsoCalledLabel)
                alsoCalledLabel.translatesAutoresizingMaskIntoConstraints = false
                alsoCalledLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
                alsoCalledLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
                alsoCalledLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 5).isActive = true
                previousView = alsoCalledLabel
            }
            
            let yearLabel = UILabel.init()
            yearLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
            yearLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
            yearLabel.numberOfLines = 0
            view.addSubview(yearLabel)
            yearLabel.translatesAutoresizingMaskIntoConstraints  = false
            yearLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
            yearLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            yearLabel.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 5).isActive = true
            if let birthYearFormatted = person.birthYear?.first?.formattedYear, let deathYearFormatted = person.deathYear?.first?.formattedYear {
                yearLabel.text = "\(birthYearFormatted) ~ \(deathYearFormatted)"
                yearLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
            } else {
                yearLabel.text = "unknown birth and death year"
                yearLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
            }
            previousView = yearLabel
            
            if let verses = person.verses {
                let seperator = UIView.init()
                seperator.backgroundColor = UIColor.init(hex: "DCDCE1")
                seperator.layer.cornerRadius = 0.5
                view.addSubview(seperator)
                seperator.translatesAutoresizingMaskIntoConstraints = false
                seperator.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
                seperator.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
                seperator.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 8).isActive = true
                seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                
                let appearsInLabel = UILabel.init()
                appearsInLabel.text = "appears in:"
                appearsInLabel.font = UIFont.systemFont(ofSize: 12, weight: .light).with(.traitItalic)
                appearsInLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
                view.addSubview(appearsInLabel)
                appearsInLabel.translatesAutoresizingMaskIntoConstraints = false
                appearsInLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
                appearsInLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 4).isActive = true
                appearsInLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
                
                let count = verses.count
                var labels: [UILabel] = []
                var n: Int = -1
                for _ in 0..<4 {
                    n += 1
                    if n == count {
                        break
                    }
                    let label = UILabel.init()
                    label.text = "» " + (verses[n].osisRef ?? "Not Found")
                    label.textColor = UIColor.init(white: 0, alpha: 0.7)
                    label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
                    view.addSubview(label)
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 16 + CGFloat(n % 2) * 75).isActive = true
                    label.topAnchor.constraint(equalTo: appearsInLabel.bottomAnchor, constant: CGFloat(n / 2) * 17 + 2).isActive = true
                    label.heightAnchor.constraint(equalToConstant: 17).isActive = true
                    labels.append(label)
                }
                previousView = n == 0 ? appearsInLabel : labels[n - 1]
            }
            
            if let description = person.description {
                let seperator = UIView.init()
                seperator.backgroundColor = UIColor.init(hex: "DCDCE1")
                seperator.layer.cornerRadius = 0.5
                view.addSubview(seperator)
                seperator.translatesAutoresizingMaskIntoConstraints = false
                seperator.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
                seperator.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
                seperator.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 8).isActive = true
                seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                 
                let descriptionTextView = UITextView.init()
                descriptionTextView.backgroundColor = UIColor.clear
                descriptionTextView.attributedText = NSAttributedString.init(string: description, attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.7), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .light)])
                view.addSubview(descriptionTextView)
                descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
                descriptionTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
                descriptionTextView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
                descriptionTextView.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 7).isActive = true
                descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
                previousView = descriptionTextView
            }
            
            views.append(view)
        }
        
        for (n, view) in views.enumerated() {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: focusedLeadingMargin + CGFloat(n) * (spacing + PersonBriefScrollView.standardSize.width)).isActive = true
            view.widthAnchor.constraint(equalToConstant: PersonBriefScrollView.standardSize.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: PersonBriefScrollView.standardSize.height).isActive = true
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        self.layoutIfNeeded()
        let last = views.last!
        self.contentSize = CGSize.init(width: last.frame.minX - focusedLeadingMargin + self.bounds.width, height: self.bounds.height)
    }
    
}
