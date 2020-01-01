//
//  CharacterBasicsViewController.swift
//  Bible
//
//  Created by Jun Ke on 9/21/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit
import MapKit

class CharacterBasicsViewController: UIViewController {
    
    var birth_place_label: UILabel?
    var birth_coordinate_label: UILabel?
    var death_place_label: UILabel?
    var death_coordinate_label: UILabel?
    var writer_of_label: UILabel?
    var description_label: UILabel?
    
    var characterID: Int = -1 {
        didSet {
            guard let info = BibleData.characterInfo(id: self.characterID) else { return }
            let scrollView = UIScrollView.init()
            self.view.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            var previousView: UIView? = nil
            //also called
            if let alsoCalled = info.alsoCalled {
                let label = UILabel.init()
                label.text = "also called"
                label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                if #available(iOS 13.0, *) {
                    label.textColor = UIColor.secondaryLabel
                } else {
                    label.textColor = UIColor.init(hex: "CFCFD3")
                }
                scrollView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
                label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 22).isActive = true
                let alsoCalledLabel = UILabel.init()
                alsoCalledLabel.text = alsoCalled
                alsoCalledLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                alsoCalledLabel.textColor = UIColor.black.withAlphaComponent(0.7)
                scrollView.addSubview(alsoCalledLabel)
                alsoCalledLabel.translatesAutoresizingMaskIntoConstraints = false
                alsoCalledLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 53).isActive = true
                alsoCalledLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
                previousView = alsoCalledLabel
            }
            //birth place
            if let birthPlaceID = info.birthPlaceID, let placeInfo = BibleData.placeInfo(id: birthPlaceID) {
                let label = UILabel.init()
                label.text = "birth place"
                label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                if #available(iOS 13.0, *) {
                    label.textColor = UIColor.secondaryLabel
                } else {
                    label.textColor = UIColor.init(hex: "CFCFD3")
                }
                scrollView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
                label.topAnchor.constraint(equalTo: previousView == nil ? scrollView.topAnchor : previousView!.bottomAnchor, constant: 22).isActive = true
                previousView = label
                if let latitude = placeInfo.latitude, let longitude = placeInfo.longitude {
                    let mapView = MKMapView.init()
                    mapView.layer.cornerRadius = 8
                    mapView.layer.borderWidth = 1
                    mapView.layer.borderColor = UIColor.init(hex: "979797").cgColor
                    mapView.setCenter(CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude), animated: false)
                    scrollView.addSubview(mapView)
                    mapView.translatesAutoresizingMaskIntoConstraints = false
                    mapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
                    mapView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
                    mapView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
                    mapView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                    previousView = mapView
                    let annotaion = MKPointAnnotation.init()
                    annotaion.title = placeInfo.name
                    annotaion.subtitle = placeInfo.featureType
                    annotaion.coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
                    mapView.addAnnotation(annotaion)
                }
                self.birth_place_label = UILabel.init()
                self.birth_place_label?.text = placeInfo.name
                self.birth_place_label?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                self.birth_place_label?.textColor = UIColor.black.withAlphaComponent(0.7)
                scrollView.addSubview(self.birth_place_label!)
                self.birth_place_label?.translatesAutoresizingMaskIntoConstraints = false
                self.birth_place_label?.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 53).isActive = true
                if previousView is UILabel {
                    self.birth_place_label?.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
                } else {
                    self.birth_place_label?.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 8).isActive = true
                }
                self.birth_coordinate_label = UILabel.init()
                self.birth_coordinate_label?.text = "(\(placeInfo.latitude == nil ? "?" : "\(placeInfo.latitude!)"), \(placeInfo.longitude == nil ? "?" : "\(placeInfo.longitude!)"))"
                self.birth_coordinate_label?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
                self.birth_coordinate_label?.textColor = UIColor.black.withAlphaComponent(0.7)
                scrollView.addSubview(self.birth_coordinate_label!)
                self.birth_coordinate_label?.translatesAutoresizingMaskIntoConstraints = false
                self.birth_coordinate_label?.leadingAnchor.constraint(equalTo: self.birth_place_label!.leadingAnchor).isActive = true
                self.birth_coordinate_label?.topAnchor.constraint(equalTo: self.birth_place_label!.bottomAnchor, constant: 6).isActive = true
                previousView = self.birth_coordinate_label
            }
            //death place
            if let deathPlaceID = info.deathPlaceID, let placeInfo = BibleData.placeInfo(id: deathPlaceID) {
                let label = UILabel.init()
                label.text = "death place"
                label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                if #available(iOS 13.0, *) {
                    label.textColor = UIColor.secondaryLabel
                } else {
                    label.textColor = UIColor.init(hex: "CFCFD3")
                }
                scrollView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
                label.topAnchor.constraint(equalTo: previousView == nil ? scrollView.topAnchor : previousView!.bottomAnchor, constant: 22).isActive = true
                previousView = label
                if let latitude = placeInfo.latitude, let longitude = placeInfo.longitude {
                    let mapView = MKMapView.init()
                    mapView.layer.cornerRadius = 8
                    mapView.layer.borderWidth = 1
                    mapView.layer.borderColor = UIColor.init(hex: "979797").cgColor
                    mapView.setCenter(CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude), animated: false)
                    scrollView.addSubview(mapView)
                    mapView.translatesAutoresizingMaskIntoConstraints = false
                    mapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
                    mapView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
                    mapView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
                    mapView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                    previousView = mapView
                    let annotaion = MKPointAnnotation.init()
                    annotaion.title = placeInfo.name
                    annotaion.coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
                    mapView.addAnnotation(annotaion)
                }
                self.death_place_label = UILabel.init()
                self.death_place_label?.text = placeInfo.name
                self.death_place_label?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                self.death_place_label?.textColor = UIColor.black.withAlphaComponent(0.7)
                scrollView.addSubview(self.death_place_label!)
                self.death_place_label?.translatesAutoresizingMaskIntoConstraints = false
                self.death_place_label?.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 53).isActive = true
                if previousView is UILabel {
                    self.death_place_label?.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
                } else {
                    self.death_place_label?.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 8).isActive = true
                }
                self.death_coordinate_label = UILabel.init()
                self.death_coordinate_label?.text = "(\(placeInfo.latitude == nil ? "?" : "\(placeInfo.latitude!)"), \(placeInfo.longitude == nil ? "?" : "\(placeInfo.longitude!)"))"
                self.death_coordinate_label?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
                self.death_coordinate_label?.textColor = UIColor.black.withAlphaComponent(0.7)
                scrollView.addSubview(self.death_coordinate_label!)
                self.death_coordinate_label?.translatesAutoresizingMaskIntoConstraints = false
                self.death_coordinate_label?.leadingAnchor.constraint(equalTo: self.death_place_label!.leadingAnchor).isActive = true
                self.death_coordinate_label?.topAnchor.constraint(equalTo: self.death_place_label!.bottomAnchor, constant: 6).isActive = true
                previousView = self.death_coordinate_label
            }
            //writer of
            if let writerOf = info.writerOf {
                let label = UILabel.init()
                label.text = "writer of"
                label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                if #available(iOS 13.0, *) {
                    label.textColor = UIColor.secondaryLabel
                } else {
                    label.textColor = UIColor.init(hex: "CFCFD3")
                }
                scrollView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
                label.topAnchor.constraint(equalTo: previousView == nil ? scrollView.topAnchor : previousView!.bottomAnchor, constant: 22).isActive = true
                let paragraphStyle = NSMutableParagraphStyle.init()
                paragraphStyle.lineSpacing = 12
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7),
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
                self.writer_of_label = UILabel.init()
                self.writer_of_label?.attributedText = NSAttributedString.init(string: writerOf.replacingOccurrences(of: "///", with: ", "), attributes: attributes)
                self.writer_of_label?.numberOfLines = 0
                scrollView.addSubview(self.writer_of_label!)
                self.writer_of_label?.translatesAutoresizingMaskIntoConstraints = false
                self.writer_of_label?.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 53).isActive = true
                self.writer_of_label?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -53).isActive = true
                self.writer_of_label?.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
                previousView = self.writer_of_label
            }
            //description
            if let description = info.description {
                let label = UILabel.init()
                label.text = "description"
                label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                if #available(iOS 13.0, *) {
                    label.textColor = UIColor.secondaryLabel
                } else {
                    label.textColor = UIColor.init(hex: "CFCFD3")
                }
                scrollView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                if previousView == nil {
                    label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 22).isActive = true
                } else {
                    label.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 22).isActive = true
                }
                label.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
                previousView = label
                let paragraphStyle = NSMutableParagraphStyle.init()
                paragraphStyle.lineSpacing = 12
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7),
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
                self.description_label = UILabel.init()
                self.description_label?.attributedText = NSAttributedString.init(string: description, attributes: attributes)
                self.description_label?.numberOfLines = 0
                scrollView.addSubview(self.description_label!)
                self.description_label?.translatesAutoresizingMaskIntoConstraints = false
                self.description_label?.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40).isActive = true
                self.description_label?.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
                self.description_label?.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
                previousView = self.description_label
            }
            self.view.layoutIfNeeded()
            scrollView.contentSize = CGSize.init(width: scrollView.bounds.width, height: previousView == nil ? 0 : previousView!.frame.maxY + 15)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 13, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }
    }
    
    override func viewWillLayoutSubviews() {
        if #available(iOS 12.0, *) {
            let user_interface_style = self.traitCollection.userInterfaceStyle
            if user_interface_style == .dark {
                self.birth_place_label?.textColor = .white
                self.birth_coordinate_label?.textColor = .white
                self.death_place_label?.textColor = .white
                self.death_coordinate_label?.textColor = .white
                self.description_label?.textColor = .white
                self.writer_of_label?.textColor = .white
            } else {
                let color = UIColor.black.withAlphaComponent(0.7)
                self.birth_place_label?.textColor = color
                self.birth_coordinate_label?.textColor = color
                self.death_place_label?.textColor = color
                self.death_coordinate_label?.textColor = color
                self.description_label?.textColor = color
                self.writer_of_label?.textColor = color
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
