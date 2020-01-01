//
//  CharacterBullitinView.swift
//  Bible
//
//  Created by Peter Ke on 2019-10-12.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol CharacterBulletinViewDelegate: class {
    func characterBulletinView(_ characterBulletinView: CharacterBulletinView, didSelectMoreWithID id: Int)
    func characterBulletinView(_ characterBulletinView: CharacterBulletinView, didSelectOsisRef osisRef: String, withID id: Int)
}

class CharacterBulletinView: UIView {

    static let standard_size: CGSize = .init(width: UIScreen.main.bounds.width - 38, height: 404)
    
    var id: Int = -1
    
    var name_layer: NameLayer?
    var osis_labels: [UILabel] = []
    var link_label: UILabel?
    var description_label: UILabel?
    
    weak var delegate: CharacterBulletinViewDelegate?
    
    init(frame: CGRect, id: Int) {
        super.init(frame: frame)
        self.id = id
        if #available(iOS 13.0, *) {
            self.backgroundColor = UIColor.systemGray6
        } else {
            self.backgroundColor = UIColor.init(hex: "F2F2F2")
        }
        let gender = BibleData.gender(id: self.id)
        
        guard let character_info = BibleData.characterInfo(id: self.id) else { return }
        
        let gender_image_view = UIImageView.init(image: UIImage.init(named: gender == 1 ? "venus" : "mars"))
        gender_image_view.contentMode = .scaleAspectFit
        gender_image_view.alpha = 0.2
        self.addSubview(gender_image_view)
        gender_image_view.translatesAutoresizingMaskIntoConstraints = false
        gender_image_view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        gender_image_view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        gender_image_view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7, constant: 0).isActive = true
        gender_image_view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7, constant: 0).isActive = true
        
        self.name_layer = NameLayer.init(id: self.id, is_root: true)
        self.name_layer?.position = .init(x: 21 + self.name_layer!.bounds.width / 2, y: 14 + self.name_layer!.bounds.height / 2)
        self.layer.addSublayer(self.name_layer!)
        
        self.description_label = UILabel.init()
        let paragraph_style = NSMutableParagraphStyle.init()
        paragraph_style.lineSpacing = 12
        self.description_label?.attributedText = NSAttributedString.init(string: character_info.description ?? "Not found", attributes: [NSAttributedString.Key.paragraphStyle : paragraph_style, NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
        self.description_label?.numberOfLines = 0
        self.addSubview(self.description_label!)
        self.description_label?.translatesAutoresizingMaskIntoConstraints = false
        self.description_label?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 29).isActive = true
        self.description_label?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -29).isActive = true
        self.description_label?.topAnchor.constraint(equalTo: self.topAnchor, constant: 73).isActive = true
        self.description_label?.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 172 / 404, constant: 0).isActive = true
        
        let link_image_view = UIImageView.init(image: UIImage.init(named: "link"))
        link_image_view.contentMode = .scaleAspectFit
        self.addSubview(link_image_view)
        link_image_view.translatesAutoresizingMaskIntoConstraints = false
        link_image_view.leadingAnchor.constraint(equalTo: self.description_label!.leadingAnchor, constant: 9).isActive = true
        link_image_view.topAnchor.constraint(equalTo: self.description_label!.bottomAnchor, constant: 5).isActive = true
        link_image_view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        link_image_view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.link_label = UILabel.init()
        self.link_label?.font = UIFont.systemFont(ofSize: 17, weight: .heavy).with(.traitItalic)
        self.link_label?.text = "Find \(gender == 1 ? "her" : "him") in"
        self.link_label?.textColor = UIColor.black.withAlphaComponent(0.7)
        self.addSubview(self.link_label!)
        self.link_label?.translatesAutoresizingMaskIntoConstraints = false
        self.link_label?.leadingAnchor.constraint(equalTo: link_image_view.trailingAnchor, constant: 7).isActive = true
        self.link_label?.centerYAnchor.constraint(equalTo: link_image_view.centerYAnchor).isActive = true
        
        if let osisRef = character_info.osisRefString?.components(separatedBy: "///") {
            var count: Int = -1
            if osisRef.count >= 4 {
                count = 4
            } else {
                count = osisRef.count
            }
            let vertical_gap: CGFloat = 9
            let horizontal_gap: CGFloat = 22
            for n in 0..<count {
                let osis_label = UILabel.init()
                osis_label.attributedText = NSAttributedString.init(string: "/" + osisRef[n] + "/", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(0.7), NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor : UIColor.black.withAlphaComponent(0.7)])
                osis_label.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.linkLabelTapped(_:))))
                self.addSubview(osis_label)
                osis_label.translatesAutoresizingMaskIntoConstraints = false
                osis_label.leadingAnchor.constraint(equalTo: self.description_label!.leadingAnchor, constant: CGFloat(n / 2) * (horizontal_gap + osis_label.intrinsicContentSize.width)).isActive = true
                osis_label.topAnchor.constraint(equalTo: self.link_label!.bottomAnchor, constant: 12 + CGFloat(n % 2) * (vertical_gap + osis_label.intrinsicContentSize.height)).isActive = true
                self.osis_labels.append(osis_label)
            }
        }
        
        //more button
        let more_button = UIButton.init()
        more_button.frame = .init(x: 0, y: 0, width: 83, height: 35)
        more_button.addTarget(self, action: #selector(self.moreButtonTouchUpInside(_:)), for: .touchUpInside)
        more_button.setTitle("More", for: .normal)
        more_button.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
        more_button.backgroundColor = gender == 1 ? UIColor.init(hex: "E3BDC4") : UIColor.init(hex: "CABAD3")
        more_button.layer.cornerRadius = 17.5
        more_button.layer.shadowPath = .init(roundedRect: more_button.bounds, cornerWidth: 17.5, cornerHeight: 17.5, transform: nil)
        more_button.layer.shadowColor = UIColor.black.cgColor
        more_button.layer.shadowRadius = 3
        more_button.layer.shadowOpacity = 0.5
        more_button.layer.shadowOffset = .zero
        self.addSubview(more_button)
        more_button.translatesAutoresizingMaskIntoConstraints = false
        more_button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        more_button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14).isActive = true
        more_button.widthAnchor.constraint(equalToConstant: more_button.bounds.width).isActive = true
        more_button.heightAnchor.constraint(equalToConstant: more_button.bounds.height).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 12.0, *) {
            let user_interface_style = self.traitCollection.userInterfaceStyle
            if user_interface_style == .dark {
                self.name_layer?.fillColor = UIColor.white.cgColor
                self.name_layer?.text_layer.foregroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
                self.description_label?.textColor = UIColor.white
                self.link_label?.textColor = UIColor.white
                for osis_label in self.osis_labels {
                    osis_label.textColor = UIColor.white
                }
            } else {
                self.name_layer?.fillColor = NameLayer.container_colors[0]
                self.name_layer?.text_layer.foregroundColor = UIColor.white.cgColor
                self.description_label?.textColor = UIColor.black.withAlphaComponent(0.7)
                self.link_label?.textColor = UIColor.black.withAlphaComponent(0.7)
                for osis_label in self.osis_labels {
                    osis_label.textColor = UIColor.black.withAlphaComponent(0.7)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func moreButtonTouchUpInside(_ sender: UIButton) {
        self.delegate?.characterBulletinView(self, didSelectMoreWithID: self.id)
    }
    
    @objc func linkLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel, let osisRef = label.text else { return }
        self.delegate?.characterBulletinView(self, didSelectOsisRef: osisRef, withID: self.id)
    }
    
}
