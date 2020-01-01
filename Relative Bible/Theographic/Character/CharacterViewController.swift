//
//  CharacterViewController.swift
//  Bible
//
//  Created by Jun Ke on 9/21/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController {
    
    var nameLabel: UILabel!
    var basicsButton: UIButton!
    var concordance_button: UIButton!
    var sectionIndicator: UIView!
    var sectionIndicatorLeadingConstraint: NSLayoutConstraint!
    var sectionIndicatorTrailingConstraint: NSLayoutConstraint!
    
    var currentSection: Int = -1
    
    var pageController: CharacterPageViewController!
    
    var characterID: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if #available(iOS 13, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }
        if self.characterID != -1 {
            self.layout()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 12.0, *) {
            let user_interface_style = self.traitCollection.userInterfaceStyle
            if user_interface_style == .dark {
                self.basicsButton.setTitleColor(UIColor.white, for: .normal)
                self.concordance_button.setTitleColor(UIColor.white, for: .normal)
                self.sectionIndicator.backgroundColor = UIColor.white
                self.nameLabel.textColor = UIColor.white
            } else {
                self.basicsButton.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
                self.concordance_button.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
                self.sectionIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                self.nameLabel.textColor = UIColor.black.withAlphaComponent(0.7)
            }
        }
    }
    
    func layout() {
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        guard let info = BibleData.characterInfo(id: self.characterID) else { return }
        self.nameLabel = UILabel.init()
        self.nameLabel.text = info.name
        self.nameLabel.textColor = UIColor.black.withAlphaComponent(0.7)
        self.nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
        self.nameLabel.numberOfLines = 0
        self.view.addSubview(self.nameLabel)
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 22).isActive = true
        let yearLabel = UILabel.init()
        yearLabel.text = self.formattedYear(info.birthYear) + " - " + self.formattedYear(info.deathYear)
        yearLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        if #available(iOS 13.0, *) {
            yearLabel.textColor = UIColor.secondaryLabel
        } else {
            yearLabel.textColor = UIColor.init(hex: "474747")
        }
        self.view.addSubview(yearLabel)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor).isActive = true
        yearLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 9).isActive = true
        
        self.basicsButton = UIButton.init()
        self.basicsButton.setTitle("BASICS", for: .normal)
        self.basicsButton.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
        self.basicsButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.basicsButton.addTarget(self, action: #selector(self.sectionButtonPressed(_:)), for: .touchUpInside)
        
        self.concordance_button = UIButton.init()
        self.concordance_button.setTitle("CONCORDANCE", for: .normal)
        self.concordance_button.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
        self.concordance_button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.concordance_button.addTarget(self, action: #selector(self.sectionButtonPressed(_:)), for: .touchUpInside)
        
        let horizontal_gap: CGFloat = 30
        let mid = (self.basicsButton.intrinsicContentSize.width + horizontal_gap + self.concordance_button.intrinsicContentSize.width) / 2
        
        self.view.addSubview(self.basicsButton)
        self.basicsButton.translatesAutoresizingMaskIntoConstraints = false
        self.basicsButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -mid).isActive = true
        self.basicsButton.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 15).isActive = true
        
        self.view.addSubview(self.concordance_button)
        self.concordance_button.translatesAutoresizingMaskIntoConstraints = false
        self.concordance_button.leadingAnchor.constraint(equalTo: self.basicsButton.trailingAnchor, constant: horizontal_gap).isActive = true
        self.concordance_button.topAnchor.constraint(equalTo: self.basicsButton.topAnchor).isActive = true
        
        self.sectionIndicator = UIView.init()
        self.sectionIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.sectionIndicator.layer.cornerRadius = 2
        self.sectionIndicator.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.addSubview(self.sectionIndicator)
        self.sectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.sectionIndicator.topAnchor.constraint(equalTo: self.basicsButton.bottomAnchor, constant: 3).isActive = true
        self.sectionIndicator.heightAnchor.constraint(equalToConstant: 4).isActive = true
        self.sectionIndicatorLeadingConstraint = self.sectionIndicator.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        self.sectionIndicatorLeadingConstraint.isActive = true
        self.sectionIndicatorTrailingConstraint = self.sectionIndicator.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        self.sectionIndicatorTrailingConstraint.isActive = true
        
        let seperator = UIView.init()
        seperator.backgroundColor = UIColor.init(hex: "C7C7CC")
        self.view.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 17).isActive = true
        seperator.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -17).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperator.topAnchor.constraint(equalTo: self.sectionIndicator.bottomAnchor).isActive = true
        
        self.pageController = CharacterPageViewController.init(transitionStyle: .scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        self.pageController.characterID = self.characterID
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.view.translatesAutoresizingMaskIntoConstraints = false
        self.pageController.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.pageController.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.pageController.view.topAnchor.constraint(equalTo: seperator.bottomAnchor).isActive = true
        self.pageController.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.view.layoutIfNeeded()
        self.pageController.didMove(toParent: self)
        
        self.pageController.delegate = self
        
        self.setSection(index: 0, animated: false)
    }
    
    func formattedYear(_ year: Int?) -> String {
        if let y = year {
            if y >= 0 {
                return "\(y) AD"
            } else {
                return "\(-y) BC"
            }
        }
        return "?"
    }
    
    func setSection(index: Int, animated: Bool) {
        if index == self.currentSection {
            return
        }
        if index == 0 {
            self.sectionIndicatorLeadingConstraint.constant = self.basicsButton.frame.minX - 2
            self.sectionIndicatorTrailingConstraint.constant = self.basicsButton.frame.maxX + 2
            self.basicsButton.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
            self.concordance_button.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
        } else if index == 1 {
            self.sectionIndicatorLeadingConstraint.constant = self.concordance_button.frame.minX - 2
            self.sectionIndicatorTrailingConstraint.constant = self.concordance_button.frame.maxX + 2
            self.basicsButton.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
            self.concordance_button.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
        }
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
        self.currentSection = index
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
