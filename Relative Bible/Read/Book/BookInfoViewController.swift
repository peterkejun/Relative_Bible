//
//  BookViewController.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class BookInfoViewController: UIViewController {
    
    var book: String = "Genesis"
    
    var infoView: UIView!
    
    var infoSectionControl: JKSegmentedControl!
    
    //info
    var bookInfoView: BookInfoView!
    var bookInfoViewLeadingConstraint: NSLayoutConstraint!
    var writerInfoView: WriterInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.lightGrayBackgroundColor
        self.navigationItem.title = book
        
        infoView = UIView.init()
        infoView.backgroundColor = UIColor.init(white: 1, alpha: 0)
        self.view.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        infoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        infoView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        layoutInfo()
        
        self.view.layoutIfNeeded()
        
        bookInfoView.fetchAndUpdate()
    }
    
    @objc func infoControlValueChanged() {
        let duration: Double = 0.2
        if infoSectionControl.selectedIndex == 0 {
            bookInfoView.isHidden = false
            bookInfoView.isUserInteractionEnabled = false
            writerInfoView.isUserInteractionEnabled = false
            UIView.animate(withDuration: duration, animations: {
                self.bookInfoViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { (_) in
                self.bookInfoView.isUserInteractionEnabled = true
                self.writerInfoView.isHidden = true
                self.writerInfoView.isUserInteractionEnabled = true
            }
        } else {
            writerInfoView.isHidden = false
            bookInfoView.isUserInteractionEnabled = false
            writerInfoView.isUserInteractionEnabled = false
            UIView.animate(withDuration: duration, animations: {
                self.bookInfoViewLeadingConstraint.constant = -self.view.bounds.width
                self.view.layoutIfNeeded()
            }) { (_) in
                self.bookInfoView.isUserInteractionEnabled = true
                self.bookInfoView.isHidden = true
                self.writerInfoView.isUserInteractionEnabled = true
            }
        }
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
