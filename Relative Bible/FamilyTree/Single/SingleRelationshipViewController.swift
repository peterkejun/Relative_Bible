//
//  SingleRelationshipViewController.swift
//  Bible
//
//  Created by Peter Ke on 2019-10-15.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class SingleRelationshipViewController: UIViewController {
    
    var family_tree: FamilyTree?
    
    var root: Int = -1
    var relationships: [Relationship] = []
    
    var relationship_picker: HorizontalPickerView?
    var self_character_view_controller: CharacterViewController?
    var relationship_scroll_view: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }
        // Do any additional setup after loading the view.
        self.relationship_picker = HorizontalPickerView.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width - 40, height: 56), items: ["Self"] + self.relationships.map({ $0.literal }))
        self.relationship_picker?.layer.cornerRadius = 8
        self.relationship_picker?.delegate = self
        self.view.addSubview(self.relationship_picker!)
        self.relationship_picker?.translatesAutoresizingMaskIntoConstraints = false
        self.relationship_picker?.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        self.relationship_picker?.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        self.relationship_picker?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.relationship_picker?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        self.relationship_picker?.isUserInteractionEnabled = true
        self.horizontalPickerView(self.relationship_picker!, didSelectItemAtIndex: 0)
        
        self.self_character_view_controller = CharacterViewController.init()
        self.self_character_view_controller?.characterID = self.root
        self.self_character_view_controller?.view.alpha = 1
        self.addChild(self.self_character_view_controller!)
        self.view.addSubview(self.self.self_character_view_controller!.view)
        self.self_character_view_controller!.view.translatesAutoresizingMaskIntoConstraints = false
        self.self_character_view_controller!.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.self_character_view_controller!.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.self_character_view_controller!.view.topAnchor.constraint(equalTo: self.relationship_picker!.bottomAnchor, constant: 0).isActive = true
        self.self_character_view_controller!.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setRoot(_ root: Int) {
        self.root = root
        //navigation bar title
        if let name = BibleData.characterName(id: self.root) {
            self.navigationItem.title = name + " is..."
        }
        //update relationships
        if let ft = self.family_tree {
            self.relationships = ft.typesOfRelationships(of: self.root)
        } else {
            self.family_tree = FamilyTree.init()
            self.relationships = self.family_tree!.typesOfRelationships(of: self.root)
        }
        //relationship picker view
        self.relationship_picker?.reset(items: self.relationships.map({ $0.literal }))
    }
    
    func createRelationshipScrollView(ofRelationship relationship: Relationship) -> (UIScrollView, SingleRelationshipView) {
        let scroll_view = UIScrollView.init(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: .greatestFiniteMagnitude))
        //single relationship view
        let single_relationship_view = SingleRelationshipView.init(frame: self.view.bounds)
        if let ft = self.family_tree {
            single_relationship_view.set(root: self.root, relationship: relationship, family_tree: ft, show: false)
        } else {
            self.family_tree = FamilyTree.init()
            single_relationship_view.set(root: self.root, relationship: relationship, family_tree: self.family_tree!, show: false)
        }
        single_relationship_view.bounds = single_relationship_view.preferredBounds()
        single_relationship_view.redraw()
        scroll_view.addSubview(single_relationship_view)
        single_relationship_view.translatesAutoresizingMaskIntoConstraints = false
        single_relationship_view.centerXAnchor.constraint(equalTo: scroll_view.centerXAnchor).isActive = true
        single_relationship_view.widthAnchor.constraint(equalToConstant: single_relationship_view.bounds.width).isActive = true
        single_relationship_view.topAnchor.constraint(equalTo: scroll_view.topAnchor).isActive = true
        single_relationship_view.heightAnchor.constraint(equalToConstant: single_relationship_view.bounds.height).isActive = true
        //seperator
        let seperator = UIView.init()
        seperator.backgroundColor = UIColor.init(hex: "6D7278")
        scroll_view.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.centerXAnchor.constraint(equalTo: scroll_view.centerXAnchor).isActive = true
        seperator.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 54).isActive = true
        seperator.topAnchor.constraint(equalTo: single_relationship_view.bottomAnchor, constant: 20).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        //bulletin views
        let relative_ids = self.family_tree!.relativesOf(id: self.root, withRelationship: relationship)
        let vertical_gap: CGFloat = 24
        let initial_vertical_gap: CGFloat = 16
        let standard_frame = CGRect.init(origin: .zero, size: CharacterBulletinView.standard_size)
        var previous_view: UIView?
        for (n, id) in relative_ids.enumerated() {
            let character_bulletin_view = CharacterBulletinView.init(frame: standard_frame, id: id)
            character_bulletin_view.delegate = self
            character_bulletin_view.layer.cornerRadius = 8
            character_bulletin_view.layer.shadowColor = UIColor.black.cgColor
            character_bulletin_view.layer.shadowRadius = 3
            character_bulletin_view.layer.shadowOpacity = 0.3
            character_bulletin_view.layer.shadowOffset = .zero
            scroll_view.addSubview(character_bulletin_view)
            character_bulletin_view.translatesAutoresizingMaskIntoConstraints = false
            character_bulletin_view.centerXAnchor.constraint(equalTo: scroll_view.centerXAnchor).isActive = true
            character_bulletin_view.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: initial_vertical_gap + CGFloat(n) * (vertical_gap + standard_frame.height)).isActive = true
            character_bulletin_view.widthAnchor.constraint(equalToConstant: standard_frame.width).isActive = true
            character_bulletin_view.heightAnchor.constraint(equalToConstant: standard_frame.height).isActive = true
            previous_view = character_bulletin_view
        }
        scroll_view.layoutIfNeeded()
        scroll_view.contentSize = CGSize.init(width: scroll_view.bounds.width, height: (previous_view?.frame.maxY ?? single_relationship_view.frame.maxY) + 10)
        scroll_view.bounds = .init(origin: .zero, size: scroll_view.contentSize)
        scroll_view.isUserInteractionEnabled = true
        return (scroll_view, single_relationship_view)
    }

}

extension SingleRelationshipViewController: HorizontalPickerViewDelegate {
    
    func horizontalPickerView(_ horizontalPickerView: HorizontalPickerView, didSelectItemAtIndex index: Int) {
        if index == 0 {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    self.relationship_scroll_view?.alpha = 0
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.self_character_view_controller?.view.alpha = 1
                }
            }) { (_) in
                self.relationship_scroll_view?.removeFromSuperview()
                self.relationship_scroll_view = nil
            }
        } else {
            let (scroll_view, single_relationship_view) = self.createRelationshipScrollView(ofRelationship: self.relationships[index - 1])
            scroll_view.alpha = 0
            print(scroll_view.layer.position)
            self.view.addSubview(scroll_view)
            scroll_view.translatesAutoresizingMaskIntoConstraints = false
            scroll_view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            scroll_view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            scroll_view.topAnchor.constraint(equalTo: horizontalPickerView.bottomAnchor, constant: 20).isActive = true
            scroll_view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            scroll_view.isScrollEnabled = true
            self.view.layoutIfNeeded()
            scroll_view.setContentOffset(.zero, animated: false)
            if let rsv = self.relationship_scroll_view {
                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeCubic, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                        rsv.alpha = 0
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        scroll_view.alpha = 1
                    }
                }) { (_) in
                    self.relationship_scroll_view?.removeFromSuperview()
                    self.relationship_scroll_view = scroll_view
                    single_relationship_view.clear()
                    single_relationship_view.setHidden(false)
                    single_relationship_view.redraw()
                }
            } else {
                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeCubic, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                        self.self_character_view_controller?.view.alpha = 0
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        scroll_view.alpha = 1
                    }
                }) { (_) in
                    single_relationship_view.clear()
                    single_relationship_view.setHidden(false)
                    single_relationship_view.redraw()
                    self.relationship_scroll_view = scroll_view
                }
            }
        }
    }
    
}

extension SingleRelationshipViewController: CharacterBulletinViewDelegate {
    
    func characterBulletinView(_ characterBulletinView: CharacterBulletinView, didSelectMoreWithID id: Int) {
        let character_view_controller = CharacterViewController.init()
        character_view_controller.characterID = id
        self.navigationController?.pushViewController(character_view_controller, animated: true)
    }
    
    func characterBulletinView(_ characterBulletinView: CharacterBulletinView, didSelectOsisRef osisRef: String, withID id: Int) {
        
    }
    
}
