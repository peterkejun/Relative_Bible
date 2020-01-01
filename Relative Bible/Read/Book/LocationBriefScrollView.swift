//
//  LocationBriefScrollView.swift
//  Bible
//
//  Created by Jun Ke on 8/1/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class LocationBriefScrollView: UIScrollView, UIScrollViewDelegate {
    
    static let standardSize: CGSize = .init(width: 324, height: 160)
    static let verticalMargin: CGFloat = 20
    
    private let focusedLeadingMargin: CGFloat = 16
    private let spacing: CGFloat = 13
    
    private(set) var locations: [GraphQL_Place] = []
    
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
            targetContentOffset.pointee.x = CGFloat(currentFocus) * (LocationBriefScrollView.standardSize.width + spacing)
        } else if velocity.x <= -triggerVelocity && currentFocus - 1 >= 0 {
            currentFocus -= 1
            targetContentOffset.pointee.x = CGFloat(currentFocus) * (LocationBriefScrollView.standardSize.width + spacing)
        } else {
            currentFocus = lrintf(Float(targetContentOffset.pointee.x) / Float(LocationBriefScrollView.standardSize.width + spacing))
            targetContentOffset.pointee.x = CGFloat(currentFocus) * (LocationBriefScrollView.standardSize.width + spacing)
        }
    }
    
    func setLocations(_ locations: [GraphQL_Place]) {
        if locations.count == 0 {
            return
        }
        for view in views {
            view.removeFromSuperview()
        }
        views.removeAll()
        self.locations = locations
        for place in self.locations {
            let view = UIView.init(frame: .init(origin: .zero, size: LocationBriefScrollView.standardSize))
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 15
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = .init(width: 0, height: 2)
            view.layer.shadowRadius = 2
            view.layer.shadowOpacity = 0.5
            
            let imageView = UIImageView.init()
            imageView.image = UIImage.init(named: "WorldMapBackground")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            //map
            if let longitude = place.longitude, let latitude = place.latitude {
                let imageView = UIImageView.init(frame: .init(origin: .zero, size: LocationBriefScrollView.standardSize))
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 15
                imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                view.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true
                
                let coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
                let camera = SnapshotCamera.init(lookingAtCenter: coordinate, fromDistance: CLLocationDistance.init(800000))
                let options = SnapshotOptions.init(styleURL: URL.init(string: "mapbox://styles/mapbox/streets-v11")!, camera: camera, size: .init(width: LocationBriefScrollView.standardSize.height, height: LocationBriefScrollView.standardSize.height))
                let marker = Marker.init(coordinate: coordinate, size: .small, iconName: "religious-christian")
                marker.color = UIColor.init(white: 0, alpha: 0.7)
                options.overlays.append(marker)
                let snapshot = Snapshot.init(options: options, accessToken: "pk.eyJ1IjoicGllcnJlYmVhc2xleSIsImEiOiJjanlzdHg1b3EwZGUyM25udTRsMjRsZTI1In0.sPhL9OwzjUENCqI2l4uWLg")
                _ = snapshot.image { (image, error) in
                    imageView.image = image
                }
            }
            
            //info
            var previousView: UIView? = nil
            
            let nameLabel = UILabel.init()
            nameLabel.text = place.name ?? "Not Found"
            nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            nameLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
            nameLabel.numberOfLines = 0
            view.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            if place.latitude != nil {
                nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LocationBriefScrollView.standardSize.height - 16).isActive = true
            } else {
                nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            }
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            previousView = nameLabel
            
            if let precision = place.precision {
                let precisionLabel = UILabel.init()
                precisionLabel.attributedText = NSAttributedString.init(string: precision, attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.7), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10, weight: .light).with(.traitItalic), NSAttributedString.Key.underlineColor : UIColor.init(white: 0, alpha: 0.7), NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
                view.addSubview(precisionLabel)
                precisionLabel.translatesAutoresizingMaskIntoConstraints = false
                precisionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
                precisionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
                precisionLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
                previousView = precisionLabel
            }
            
            if let featureType = place.featureType {
                let featureTypeLabel = UILabel.init()
                featureTypeLabel.text = featureType
                featureTypeLabel.textColor = UIColor.init(white: 0, alpha: 0.7)
                featureTypeLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
                view.addSubview(featureTypeLabel)
                featureTypeLabel.translatesAutoresizingMaskIntoConstraints = false
                featureTypeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
                featureTypeLabel.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 5).isActive = true
                previousView = featureTypeLabel
            }
            
            if let description = place.description {
                let descriptionLabel = UILabel.init()
                descriptionLabel.attributedText = NSAttributedString.init(string: description, attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.7), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .light)])
                descriptionLabel.numberOfLines = 0
                view.addSubview(descriptionLabel)
                descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
                descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
                descriptionLabel.trailingAnchor.constraint(equalTo: place.latitude == nil ? view.trailingAnchor : nameLabel.trailingAnchor, constant: place.latitude == nil ? -16 : 0).isActive = true
                descriptionLabel.topAnchor.constraint(equalTo: previousView!.bottomAnchor).isActive = true
                descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
                previousView = descriptionLabel
            }
            
            views.append(view)
        }
        
        for (n, view) in views.enumerated() {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: focusedLeadingMargin + CGFloat(n) * (spacing + LocationBriefScrollView.standardSize.width)).isActive = true
            view.widthAnchor.constraint(equalToConstant: LocationBriefScrollView.standardSize.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: LocationBriefScrollView.standardSize.height).isActive = true
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        self.layoutIfNeeded()
        let last = views.last!
        self.contentSize = CGSize.init(width: last.frame.minX - focusedLeadingMargin + self.bounds.width, height: self.bounds.height)
        
        for view in views {
            _ = view.setGradientBackground(top: UIColor.white, bottom: UIColor.init(hex: "FAFAFA"), cornerRadius: 15)
        }
    }
    
}
