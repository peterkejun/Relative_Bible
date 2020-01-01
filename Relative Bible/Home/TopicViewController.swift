//
//  TopicViewController.swift
//  Bible
//
//  Created by Jun Ke on 8/24/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    var topic: String = "God"
    var topicColor = UIColor.black.withAlphaComponent(0.7)
    var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if #available(iOS 13, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }
        self.navigationItem.title = self.topic + "?"
        if let topicContentRaw = BibleData.discussion(topic: self.topic) {
            self.sections = self.parseRawContent(content: topicContentRaw)
        }
        self.layoutSections()
    }
    
    private func layoutSections() {
        var color = UIColor.black.withAlphaComponent(0.7)
        if #available(iOS 13.0, *) {
            color = UIColor.label.withAlphaComponent(0.7)
        }
        
        self.scrollView = UIScrollView.init()
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let indicatorWidth: CGFloat = 5
        let indicatorView = UIView.init(frame: .init(x: 0, y: 0, width: 40, height: CGFloat.greatestFiniteMagnitude))
        indicatorView.backgroundColor = UIColor.clear
        self.scrollView.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        indicatorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        let indicatorViewHeightConstraint = indicatorView.heightAnchor.constraint(equalToConstant: CGFloat.greatestFiniteMagnitude)
        indicatorViewHeightConstraint.isActive = true
        
        var previousSectionLastView: UIView? = nil
        
        for section in sections {
            var firstView: UIView? = nil
            var previousView: UIView? = nil
            //section header
            if let sectionHeader = section.sectionHeader {
                let sectionLabel = UILabel.init()
                sectionLabel.text = sectionHeader
                sectionLabel.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
                sectionLabel.textColor = color
                sectionLabel.numberOfLines = 0
                scrollView.addSubview(sectionLabel)
                sectionLabel.translatesAutoresizingMaskIntoConstraints = false
                if let pslv = previousSectionLastView {
                    sectionLabel.topAnchor.constraint(equalTo: pslv.bottomAnchor, constant: 40).isActive = true
                } else {
                    sectionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
                }
                sectionLabel.leadingAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: 10).isActive = true
                sectionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                previousView = sectionLabel
                firstView = sectionLabel
            }
            //points
            var pointLabels: [UILabel] = []
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineSpacing = 4
            for point in section.points {
                point.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: point.length))
                point.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange.init(location: 0, length: point.length))
                let pointLabel = UILabel.init()
                pointLabel.attributedText = point
                pointLabel.numberOfLines = 0
                scrollView.addSubview(pointLabel)
                pointLabel.translatesAutoresizingMaskIntoConstraints = false
                if let pv = previousView {
                    //there is a section header or a previous point
                    pointLabel.topAnchor.constraint(equalTo: pv.bottomAnchor, constant: 20).isActive = true
                } else if let pslv = previousSectionLastView {
                    //there is a previous section but no section header or previous point
                    pointLabel.topAnchor.constraint(equalTo: pslv.bottomAnchor, constant: 40).isActive = true
                    firstView = pointLabel
                } else {
                    //there is no previous section or a section header or a previous point
                    pointLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
                    firstView = pointLabel
                }
                pointLabel.leadingAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: 10).isActive = true
                pointLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                previousView = pointLabel
                pointLabels.append(pointLabel)
            }
            
            //update last section
            previousSectionLastView = previousView
            
            //section indicator
            if let fv = firstView, let pv = previousView {
                let indicator = UIView.init()
                indicator.backgroundColor = color
                indicator.layer.cornerRadius = indicatorWidth / 2
                indicatorView.addSubview(indicator)
                indicator.translatesAutoresizingMaskIntoConstraints = false
                indicator.topAnchor.constraint(equalTo: fv.topAnchor, constant: -5).isActive = true
                indicator.leadingAnchor.constraint(equalTo: indicatorView.leadingAnchor, constant: 15).isActive = true
                indicator.widthAnchor.constraint(equalToConstant: indicatorWidth).isActive = true
                indicator.bottomAnchor.constraint(equalTo: pv.bottomAnchor, constant: 5).isActive = true
            }
            //point indicators
            for pointLabel in pointLabels {
                let indicator = UIView.init()
                indicator.backgroundColor = color.withAlphaComponent(0.5)
                indicator.layer.cornerRadius = indicatorWidth / 2
                indicatorView.addSubview(indicator)
                indicator.translatesAutoresizingMaskIntoConstraints = false
                indicator.topAnchor.constraint(equalTo: pointLabel.topAnchor).isActive = true
                indicator.bottomAnchor.constraint(equalTo: pointLabel.bottomAnchor).isActive = true
                indicator.leadingAnchor.constraint(equalTo: indicatorView.leadingAnchor, constant: 25).isActive = true
                indicator.widthAnchor.constraint(equalToConstant: indicatorWidth).isActive = true
            }
        }
        
        self.scrollView.layoutIfNeeded()
        indicatorViewHeightConstraint.constant = previousSectionLastView?.frame.maxY ?? scrollView.bounds.height
        
        //credit
        let creditLabel = UILabel.init()
        let creditAttributedText = NSMutableAttributedString.init(string: "Information provided by www.bibleInfo.com\nCopyright © 2019, Bibleinfo.com", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        creditAttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.italicSystemFont(ofSize: 14), range: NSRange.init(location: 24, length: 17))
        creditAttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: NSRange.init(location: 0, length: 23))
        creditAttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: NSRange.init(location: 41, length: 32))
        creditLabel.attributedText = creditAttributedText
        creditLabel.numberOfLines = 0
        scrollView.addSubview(creditLabel)
        creditLabel.translatesAutoresizingMaskIntoConstraints = false
        creditLabel.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 15).isActive = true
        creditLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.scrollView.layoutIfNeeded()
        self.scrollView.contentSize = CGSize.init(width: self.scrollView.bounds.width, height: creditLabel.frame.maxY + 10)
    }
    
    private func parseRawContent(content: String) -> [Section] {
        var sections: [Section] = []
        //look for ]]] sections
        if content.contains("\n") {
            let sectionsRaw = content.components(separatedBy: "\n")
            for sectionRaw in sectionsRaw {
                let section = Section.init()
                //get section header
                var components: [String] = []
                if sectionRaw.contains("]]]") {
                    let sectionRawComponents = sectionRaw.components(separatedBy: "]]]")
                    section.sectionHeader = sectionRawComponents[0]
                    components = sectionRawComponents[1].components(separatedBy: "///")
                } else {
                    components = sectionRaw.components(separatedBy: "///")
                }
                //split points
                for pointRaw in components {
                    if pointRaw.starts(with: "{") {
                        let closingBracketRange = (pointRaw as NSString).range(of: "}")
                        let pointString = (pointRaw as NSString).replacingCharacters(in: closingBracketRange, with: "").dropFirst() as NSString
                        let attributedString = NSMutableAttributedString.init(string: pointString as String)
                        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .light), range: NSRange.init(location: 0, length: attributedString.length))
                        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: NSRange.init(location: 0, length: closingBracketRange.location - 2))
                        if closingBracketRange.location < attributedString.length {
                            attributedString.insert(.init(string: "\n"), at: closingBracketRange.location)
                        }
                        section.points.append(attributedString)
                    } else {
                        let attributedString = NSMutableAttributedString.init(string: pointRaw)
                        let firstSentenceRange = (pointRaw as NSString).rangeOfFirstSentence
                        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .light), range: NSRange.init(location: 0, length: attributedString.length))
                        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: firstSentenceRange)
                        if firstSentenceRange.length + 2 < attributedString.length {
                            attributedString.insert(NSAttributedString.init(string: "\n"), at: firstSentenceRange.length + 2)
                        }
                        section.points.append(attributedString)
                    }
                }
                sections.append(section)
            }
        } else {
            let section = Section.init()
            //get section header
            var components: [String] = []
            if content.contains("]]]") {
                let contentComponents = content.components(separatedBy: "]]]")
                section.sectionHeader = contentComponents[0]
                components = contentComponents[1].components(separatedBy: "///")
            } else {
                components = content.components(separatedBy: "///")
            }
            //split points
            for pointRaw in components {
                if pointRaw.starts(with: "{") {
                    let closingBracketRange = (pointRaw as NSString).range(of: "}")
                    let pointString = (pointRaw as NSString).replacingCharacters(in: closingBracketRange, with: "").dropFirst() as NSString
                    let attributedString = NSMutableAttributedString.init(string: pointString as String)
                    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .light), range: NSRange.init(location: 0, length: attributedString.length))
                    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: NSRange.init(location: 0, length: closingBracketRange.location - 2))
                    if closingBracketRange.location < attributedString.length {
                        attributedString.insert(.init(string: "\n"), at: closingBracketRange.location)
                    }
                    section.points.append(attributedString)
                } else {
                    let attributedString = NSMutableAttributedString.init(string: pointRaw)
                    let firstSentenceRange = (pointRaw as NSString).rangeOfFirstSentence
                    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .light), range: NSRange.init(location: 0, length: attributedString.length))
                    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: firstSentenceRange)
                    if firstSentenceRange.length + 2 < attributedString.length {
                        attributedString.insert(NSAttributedString.init(string: "\n"), at: firstSentenceRange.length + 2)
                    }
                    section.points.append(attributedString)
                }
            }
            sections.append(section)
        }
        return sections
    }
    
    class Section {
        var sectionHeader: String? = nil
        var points: [NSMutableAttributedString] = []
        
        init() {
            self.sectionHeader = nil
            self.points = []
        }
        
        init(sectionHeader: String, points: [NSMutableAttributedString]) {
            self.sectionHeader = sectionHeader
            self.points = points
        }
    }
    
}

fileprivate extension NSString {
    var rangeOfFirstSentence: NSRange {
        let periodRange = self.range(of: ".")
        let exclamationRange = self.range(of: "!")
        let questionRange = self.range(of: "?")
        var effectiveRanges: [NSRange] = []
        if periodRange.location != NSNotFound {
            effectiveRanges.append(periodRange)
        }
        if exclamationRange.location != NSNotFound {
            effectiveRanges.append(exclamationRange)
        }
        if questionRange.location != NSNotFound {
            effectiveRanges.append(questionRange)
        }
        var minLocation: Int = self.length - 1
        for r in effectiveRanges {
            if r.location <= minLocation {
                minLocation = r.location
            }
        }
        return NSRange.init(location: 0, length: minLocation)
    }
}


