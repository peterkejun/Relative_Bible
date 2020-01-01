//
//  BookBriefScrollView.swift
//  Bible
//
//  Created by Jun Ke on 8/3/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class BookBriefScrollView: UIScrollView, UIScrollViewDelegate {
    
    static let standardSize: CGSize = .init(width: 209, height: 209)
    static let verticalMargin: CGFloat = 20
    
    private let focusedLeadingMargin: CGFloat = 16
    private let spacing: CGFloat = 13
    
    private(set) var books: [GraphQL_Book] = []
    
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
            targetContentOffset.pointee.x = CGFloat(currentFocus) * (BookBriefScrollView.standardSize.width + spacing)
        } else if velocity.x <= -triggerVelocity && currentFocus - 1 >= 0 {
            currentFocus -= 1
            targetContentOffset.pointee.x = CGFloat(currentFocus) * (BookBriefScrollView.standardSize.width + spacing)
        } else {
            currentFocus = lrintf(Float(targetContentOffset.pointee.x) / Float(BookBriefScrollView.standardSize.width + spacing))
            targetContentOffset.pointee.x = CGFloat(currentFocus) * (BookBriefScrollView.standardSize.width + spacing)
        }
    }
    
    func setBooks(_ books: [GraphQL_Book]) {
        for view in views {
            view.removeFromSuperview()
        }
        views.removeAll()
        self.books = books
        for book in self.books {
            let view = UIView.init(frame: .init(origin: .zero, size: BookBriefScrollView.standardSize))
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 15
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = .init(width: 0, height: 2)
            view.layer.shadowRadius = 2
            view.layer.shadowOpacity = 0.5
            
            let imageView = UIImageView.init()
            imageView.image = UIImage.init(named: "BookBackground")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            let bookLabel = UILabel.init()
            bookLabel.text = book.title
            bookLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            bookLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
            bookLabel.textAlignment = .center
            view.addSubview(bookLabel)
            bookLabel.translatesAutoresizingMaskIntoConstraints = false
            bookLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            bookLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            bookLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
            bookLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            let divisionLabel = UILabel.init()
            divisionLabel.text = BibleData.division(book: book.title ?? "Genesis")
            divisionLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
            divisionLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
            divisionLabel.textAlignment = .center
            view.addSubview(divisionLabel)
            divisionLabel.translatesAutoresizingMaskIntoConstraints = false
            divisionLabel.leadingAnchor.constraint(equalTo: bookLabel.leadingAnchor).isActive = true
            divisionLabel.trailingAnchor.constraint(equalTo: bookLabel.trailingAnchor).isActive = true
            divisionLabel.topAnchor.constraint(equalTo: bookLabel.bottomAnchor, constant: 3).isActive = true
            divisionLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
            
            let seperator1 = UIView.init()
            seperator1.backgroundColor = UIColor.init(hex: "DCDCE1")
            seperator1.layer.cornerRadius = 0.5
            view.addSubview(seperator1)
            seperator1.translatesAutoresizingMaskIntoConstraints = false
            seperator1.leadingAnchor.constraint(equalTo: bookLabel.leadingAnchor).isActive = true
            seperator1.trailingAnchor.constraint(equalTo: bookLabel.trailingAnchor).isActive = true
            seperator1.topAnchor.constraint(equalTo: divisionLabel.bottomAnchor, constant: 8).isActive = true
            seperator1.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            var previousView: UIView? = seperator1
            
            if let writers = book.writers {
                let writerLabel = UILabel.init()
                writerLabel.text = writers.count == 1 ? "Writer:" : "Writers:"
                writerLabel.font = UIFont.systemFont(ofSize: 12, weight: .light).with(.traitItalic)
                writerLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
                view.addSubview(writerLabel)
                writerLabel.translatesAutoresizingMaskIntoConstraints = false
                writerLabel.leadingAnchor.constraint(equalTo: bookLabel.leadingAnchor).isActive = true
                writerLabel.topAnchor.constraint(equalTo: seperator1.bottomAnchor, constant: 12).isActive = true
                writerLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
                writerLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
                
                let writerValueLabel = UILabel.init()
                var valueText = String.init()
                for (n, writer) in writers.enumerated() {
                    valueText.append(writer.name ?? "Not Found")
                    if n != writers.count - 1 {
                        valueText.append(", ")
                    }
                }
                writerValueLabel.text = valueText
                writerValueLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
                writerValueLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
                writerValueLabel.textAlignment = .left
                view.addSubview(writerValueLabel)
                writerValueLabel.translatesAutoresizingMaskIntoConstraints = false
                writerValueLabel.leadingAnchor.constraint(equalTo: writerLabel.trailingAnchor, constant: 3).isActive = true
                writerValueLabel.firstBaselineAnchor.constraint(equalTo: writerLabel.firstBaselineAnchor).isActive = true
                writerValueLabel.trailingAnchor.constraint(equalTo: bookLabel.trailingAnchor).isActive = true
                writerValueLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
                previousView = writerValueLabel
            }
            
            let numChaptersLabel = UILabel.init()
            let numChaptersAttributedText = NSMutableAttributedString.init(string: "Number of chapters: \(BibleData.numChaptersDict[book.title ?? "Genesis"]!)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.7)])
            numChaptersAttributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 12, weight: .light).with(.traitItalic), range: NSRange.init(location: 0, length: 19))
            numChaptersAttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12, weight: .semibold), range: NSRange.init(location: 19, length: numChaptersAttributedText.length - 19))
            numChaptersLabel.attributedText = numChaptersAttributedText
            view.addSubview(numChaptersLabel)
            numChaptersLabel.translatesAutoresizingMaskIntoConstraints = false
            numChaptersLabel.leadingAnchor.constraint(equalTo: bookLabel.leadingAnchor).isActive = true
            numChaptersLabel.trailingAnchor.constraint(equalTo: bookLabel.trailingAnchor).isActive = true
            numChaptersLabel.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 5).isActive = true
            numChaptersLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
            
            let seperator2 = UIView.init()
            seperator2.backgroundColor = UIColor.init(hex: "DCDCE1")
            seperator2.layer.cornerRadius = 0.5
            view.addSubview(seperator2)
            seperator2.translatesAutoresizingMaskIntoConstraints = false
            seperator2.leadingAnchor.constraint(equalTo: bookLabel.leadingAnchor).isActive = true
            seperator2.trailingAnchor.constraint(equalTo: bookLabel.trailingAnchor).isActive = true
            seperator2.topAnchor.constraint(equalTo: numChaptersLabel.bottomAnchor, constant: 8).isActive = true
            seperator2.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            let description = "The book of Genesis is the first book of the Bible, and opens with one of the most famous first sentences of any literary work: “In the beginning, God created the heavens and the earth.” It’s where we find the famous stories of Adam and Eve, Cain and Abel, Noah and the ark, Abraham and Isaac, and a well-dressed dreamer named Joseph.\nOn its own, the book of Genesis reads like a string of epic stories: a semi-tragic saga of a world that just keeps going wrong, despite its Creator’s intentions. But Genesis isn’t a stand-alone book. It’s the first installment in the five-part Torah (or Pentateuch), which is the foundational work of the Old Testament. The Torah is Israel’s origin story: it’s the history of how the nation of Israel got its population, its land, and its religion."
            let descriptionTextView = UITextView.init()
            descriptionTextView.backgroundColor = UIColor.clear
            descriptionTextView.attributedText = NSAttributedString.init(string: description, attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.7), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .light)])
            view.addSubview(descriptionTextView)
            descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
            descriptionTextView.leadingAnchor.constraint(equalTo: bookLabel.leadingAnchor).isActive = true
            descriptionTextView.trailingAnchor.constraint(equalTo: bookLabel.trailingAnchor).isActive = true
            descriptionTextView.topAnchor.constraint(equalTo: seperator2.bottomAnchor, constant: 7).isActive = true
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
            
            views.append(view)
        }
        
        for (n, view) in views.enumerated() {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: focusedLeadingMargin + CGFloat(n) * (spacing + BookBriefScrollView.standardSize.width)).isActive = true
            view.widthAnchor.constraint(equalToConstant: BookBriefScrollView.standardSize.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: BookBriefScrollView.standardSize.height).isActive = true
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        self.layoutIfNeeded()
        let last = views.last!
        self.contentSize = CGSize.init(width: last.frame.minX - focusedLeadingMargin + self.bounds.width, height: self.bounds.height)
    }
    
}
