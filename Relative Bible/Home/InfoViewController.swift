//
//  InfoViewController.swift
//  Bible
//
//  Created by Peter Ke on 2019-11-07.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    var scroll_view: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Info & Credits"
        
        self.scroll_view = UIScrollView.init()
        self.view.addSubview(self.scroll_view)
        self.scroll_view.translatesAutoresizingMaskIntoConstraints = false
        self.scroll_view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scroll_view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scroll_view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scroll_view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let verse_label = UILabel.init()
        let paragraph_style = NSMutableParagraphStyle.init()
        paragraph_style.lineSpacing = 0
        if #available(iOS 13.0, *) {
            let verse_attributed_text = NSAttributedString.init(string: "Whoever has ears, \nlet them hear.", attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.label,
                NSAttributedString.Key.paragraphStyle : paragraph_style,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular).with(.traitItalic)
            ])
            verse_label.attributedText = verse_attributed_text
        } else {
            let verse_attributed_text = NSAttributedString.init(string: "Whoever has ears, \nlet them hear.", attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(0.7),
                NSAttributedString.Key.paragraphStyle : paragraph_style,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular).with(.traitItalic)
            ])
            verse_label.attributedText = verse_attributed_text
        }
        verse_label.textAlignment = .center
        verse_label.numberOfLines = 0
        self.scroll_view.addSubview(verse_label)
        verse_label.translatesAutoresizingMaskIntoConstraints = false
        verse_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        verse_label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        verse_label.topAnchor.constraint(equalTo: self.scroll_view.topAnchor, constant: 20).isActive = true
        
        let source_label = UILabel.init()
        source_label.textAlignment = .right
        source_label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        source_label.text = "Matthew 11:15 NIV"
        self.scroll_view.addSubview(source_label)
        source_label.translatesAutoresizingMaskIntoConstraints = false
        source_label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        source_label.topAnchor.constraint(equalTo: verse_label.bottomAnchor, constant: 22).isActive = true
        
        let seperator1 = self.seperator
        seperator1.layer.cornerRadius = 0.5
        self.scroll_view.addSubview(seperator1)
        seperator1.translatesAutoresizingMaskIntoConstraints = false
        seperator1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        seperator1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        seperator1.topAnchor.constraint(equalTo: source_label.bottomAnchor, constant: 28).isActive = true
        seperator1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let content_label = UILabel.init()
        paragraph_style.lineSpacing = 26
        paragraph_style.firstLineHeadIndent = 34
        let content = "When I look back at the younger self who treatures the temptations of a sinful life, I am reminded of the graces He gives upon me. Jesus has changed my life in amazing ways and it has been my mission to spread the gospel since the day I was baptized. I am grateful that God answered my prayer and helped me along the way. This app could not be done without the Theographics project by Viz.Bible.\nhttps://m.viz.bible/\n\"Whoever has ears, let them hear.\" I hope that one day someone who puts his faith in Jesus finds this useful."
        if #available(iOS 13.0, *) {
            let content_attributed_text = NSAttributedString.init(string: content, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.label,
                NSAttributedString.Key.paragraphStyle : paragraph_style,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .bold).with(.traitItalic)
            ])
            content_label.attributedText = content_attributed_text
        } else {
            let content_attributed_text = NSAttributedString.init(string: content, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(0.7),
                NSAttributedString.Key.paragraphStyle : paragraph_style,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .bold).with(.traitItalic)
            ])
            content_label.attributedText = content_attributed_text
        }
        content_label.textAlignment = .center
        content_label.numberOfLines = 0
        self.scroll_view.addSubview(content_label)
        content_label.translatesAutoresizingMaskIntoConstraints = false
        content_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        content_label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        content_label.topAnchor.constraint(equalTo: seperator1.bottomAnchor, constant: 20).isActive = true
        
        let seperator2 = self.seperator
        seperator2.layer.cornerRadius = 0.5
        self.scroll_view.addSubview(seperator2)
        seperator2.translatesAutoresizingMaskIntoConstraints = false
        seperator2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        seperator2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        seperator2.topAnchor.constraint(equalTo: content_label.bottomAnchor, constant: 20).isActive = true
        seperator2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.scroll_view.layoutIfNeeded()
        self.scroll_view.contentSize = CGSize.init(width: self.view.bounds.width, height: seperator2.frame.maxY + 20)
    }
    
    var seperator: UIView {
        let v = UIView.init()
        v.backgroundColor = UIColor.init(hex: "5856D6")
        return v
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
