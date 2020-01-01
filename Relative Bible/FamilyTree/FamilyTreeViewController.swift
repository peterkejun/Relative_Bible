//
//  SphereViewController.swift
//  Bible
//
//  Created by Jun Ke on 9/25/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit
import SceneKit

class FamilyTreeViewController: UIViewController {
        
    var family_tree: FamilyTree!
    var family_tree_view: FamilyTreeView!
    var legend_view: UIView!
    var legend_labels: [UILabel] = []
    
    var focus_id: Int = -1 {
        didSet {
            self.navigationItem.title = BibleData.characterName(id: self.focus_id)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.init(image: UIImage.init(named: "info"), style: .plain, target: self, action: #selector(self.infoBarButtonPressed(_:))),
            UIBarButtonItem.init(image: UIImage.init(named: "eye"), style: .plain, target: self, action: #selector(self.legendBarButtonPressed(_:))),
            UIBarButtonItem.init(image: UIImage.init(named: "users"), style: .plain, target: self, action: #selector(self.personBarButtonPressed(_:)))
        ]
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem.init(image: UIImage.init(named: "minus"), style: .plain, target: self, action: #selector(self.minusBarButtonPressed(_:))),
            UIBarButtonItem.init(image: UIImage.init(named: "plus"), style: .plain, target: self, action: #selector(self.plusBarButtonPressed(_:)))
        ]
        
        self.family_tree = FamilyTree.init()
        self.focus_id = 2108
        
        self.family_tree_view = FamilyTreeView.init(frame: self.view.bounds, family_tree: self.family_tree)
        self.family_tree_view.delegate = self
        self.view.addSubview(self.family_tree_view)
        self.family_tree_view.translatesAutoresizingMaskIntoConstraints = false
        self.family_tree_view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.family_tree_view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.family_tree_view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.family_tree_view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        (self.legend_view, self.legend_labels) = self.createLegendView(withInsets: UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10))
        self.view.addSubview(self.legend_view)
        self.legend_view.translatesAutoresizingMaskIntoConstraints = false
        self.legend_view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.legend_view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.legend_view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.legend_view.heightAnchor.constraint(equalToConstant: self.legend_view.bounds.height).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isMovingToParent {
            self.family_tree_view.resetRoot(withCharacterID: self.focus_id)
            self.family_tree_view.layout(withLayoutSize: self.family_tree_view.current_size)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 12.0, *) {
            let user_interface_style = self.traitCollection.userInterfaceStyle
            if user_interface_style == .dark {
                for label in self.legend_labels {
                    label.textColor = UIColor.white
                }
            } else {
                for label in self.legend_labels {
                    label.textColor = UIColor.black.withAlphaComponent(0.7)
                }
            }
        }
    }
    
    @objc func infoBarButtonPressed(_ sender: UIBarButtonItem) {
        let single_relationship_view_controller = SingleRelationshipViewController.init()
        single_relationship_view_controller.family_tree = self.family_tree
        single_relationship_view_controller.setRoot(self.focus_id)
        self.navigationController?.pushViewController(single_relationship_view_controller, animated: true)
    }
    
    @objc func legendBarButtonPressed(_ sender: UIBarButtonItem) {
        if self.legend_view.isHidden {
            self.legend_view.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.legend_view.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.legend_view.alpha = 0
            }) { (_) in
                self.legend_view.isHidden = true
            }
        }
    }
    
    @objc func personBarButtonPressed(_ sender: UIBarButtonItem) {
        let characters_view_controller = CharactersViewController.init()
        characters_view_controller.delegate = self
        self.present(UINavigationController.init(rootViewController: characters_view_controller), animated: true, completion: nil)
    }
    
    @objc func plusBarButtonPressed(_ sender: UIBarButtonItem) {
        self.family_tree_view.incrementSize()
    }
    
    @objc func minusBarButtonPressed(_ sender: UIBarButtonItem) {
        self.family_tree_view.decrementSize()
    }
    
    func createLegendView(withInsets insets: UIEdgeInsets) -> (UIView, [UILabel]) {
        let legend_view = UIView.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: .greatestFiniteMagnitude))
        if #available(iOS 13.0, *) {
            legend_view.backgroundColor = UIColor.systemGray5
        } else {
            legend_view.backgroundColor = UIColor.init(hex: "F2F2F2")
        }
        //labels
        let vertical_gap: CGFloat = 5
        let horizontal_gap: CGFloat = 20
        let uniform_width: CGFloat = 100
        var labels: [UILabel] = []
        let relationships = Relationship.common_cases
        for (n, relationship) in relationships.enumerated() {
            let label = UILabel.init()
            label.text = relationship.shortened
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = UIColor.black.withAlphaComponent(0.7)
            legend_view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: legend_view.leadingAnchor, constant: CGFloat(n % 2) * (uniform_width + horizontal_gap) + insets.left).isActive = true
            label.topAnchor.constraint(equalTo: legend_view.topAnchor, constant: CGFloat(n / 2) * (label.intrinsicContentSize.height + vertical_gap) + insets.top).isActive = true
            labels.append(label)
        }
        let female_label = UILabel.init()
        female_label.text = "Female"
        female_label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        female_label.textColor = UIColor.black.withAlphaComponent(0.7)
        legend_view.addSubview(female_label)
        female_label.translatesAutoresizingMaskIntoConstraints = false
        female_label.trailingAnchor.constraint(equalTo: legend_view.trailingAnchor, constant: -5 - insets.right).isActive = true
        female_label.topAnchor.constraint(equalTo: legend_view.topAnchor, constant: insets.top).isActive = true
        let male_Label = UILabel.init()
        male_Label.text = "Male"
        male_Label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        male_Label.textColor = UIColor.black.withAlphaComponent(0.7)
        legend_view.addSubview(male_Label)
        male_Label.translatesAutoresizingMaskIntoConstraints = false
        male_Label.leadingAnchor.constraint(equalTo: female_label.leadingAnchor).isActive = true
        male_Label.topAnchor.constraint(equalTo: female_label.bottomAnchor, constant: vertical_gap).isActive = true
        legend_view.layoutIfNeeded()
        legend_view.bounds = .init(x: 0, y: 0, width: legend_view.bounds.width, height: (labels.last?.frame.maxY ?? male_Label.frame.maxY) + insets.bottom)
        //indicators
        let indicator_height: CGFloat = 4
        for (n, label) in labels.enumerated() {
            let indicator_layer = CALayer.init()
            indicator_layer.bounds = .init(x: 0, y: 0, width: uniform_width - label.bounds.width - 6, height: indicator_height)
            indicator_layer.anchorPoint = .init(x: 0, y: 0.5)
            indicator_layer.position = .init(x: label.frame.maxX + 6, y: label.frame.midY)
            indicator_layer.cornerRadius = indicator_height / 2
            indicator_layer.backgroundColor = relationships[n].color.cgColor
            legend_view.layer.addSublayer(indicator_layer)
        }
        let gender_indicator_height: CGFloat = 16
        let female_indicator = CALayer.init()
        female_indicator.backgroundColor = UIColor.init(hex: "F4CED5").cgColor
        female_indicator.cornerRadius = gender_indicator_height / 2
        female_indicator.anchorPoint = .init(x: 1, y: 0.5)
        female_indicator.bounds = .init(x: 0, y: 0, width: gender_indicator_height, height: gender_indicator_height)
        female_indicator.position = .init(x: female_label.frame.minX - 6, y: female_label.frame.midY)
        legend_view.layer.addSublayer(female_indicator)
        let male_indicator = CALayer.init()
        male_indicator.backgroundColor = UIColor.init(hex: "E6D6EF").cgColor
        male_indicator.cornerRadius = gender_indicator_height / 2
        male_indicator.anchorPoint = .init(x: 1, y: 0.5)
        male_indicator.bounds = .init(x: 0, y: 0, width: gender_indicator_height, height: gender_indicator_height)
        male_indicator.position = .init(x: male_Label.frame.minX - 6, y: male_Label.frame.midY)
        legend_view.layer.addSublayer(male_indicator)
        return (legend_view, labels + [female_label, male_Label])
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

extension FamilyTreeViewController: FamilyTreeViewDelegate {
    
    func familyTreeView(_ familyTreeView: FamilyTreeView, didSelectWithID id: Int) {
        self.focus_id = id
    }
    
}

extension FamilyTreeViewController: CharactersViewControllerDelegate {
    
    func charactersViewController(_ view_controller: UIViewController, didSelectCharacterOfID id: Int) {
        self.family_tree_view.setRoot(id)
    }

}
