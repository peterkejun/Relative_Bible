//
//  TextOptionsViewController.swift
//  Bible
//
//  Created by Jun Ke on 8/5/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol TextOptionsViewControllerDelegate: class {
    func textOptionsViewController(_ viewController: TextOptionsViewController, didChangeFontSizeWithDirection direction: Int)
    func textOptionsViewController(_ viewController: TextOptionsViewController, didChooseNewTheme theme: TextOptionsViewController.Theme)
}

class TextOptionsViewController: UIViewController {
    
    weak var delegate: TextOptionsViewControllerDelegate?
    
    let mainScreen = UIScreen.main
    
    var brightnessSlider: UISlider!
    var smallerTextButton: UIButton!
    var largerTextButton: UIButton!
    
    private(set) var currentTheme: Theme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let savedTheme = UserDefaults.standard.integer(forKey: "reading theme")
        if savedTheme == 0 {
            self.currentTheme = .classic
        } else {
            self.currentTheme = Theme.init(rawValue: savedTheme - 1) ?? .classic
        }
        
        self.view.backgroundColor = UIColor.init(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
        
        self.brightnessSlider = UISlider.init()
        self.brightnessSlider.maximumValueImage = UIImage.init(named: "brightness large")
        self.brightnessSlider.minimumValueImage = UIImage.init(named: "brightness small")?.withAlignmentRectInsets(.init(top: 10, left: 10, bottom: 10, right: 10))
        self.brightnessSlider.maximumTrackTintColor = UIColor.init(red: 99/255, green: 99/255, blue: 102/255, alpha: 1.0).withAlphaComponent(0.25)
        self.brightnessSlider.minimumTrackTintColor = UIColor.white
        self.brightnessSlider.maximumValue = 1
        self.brightnessSlider.minimumValue = 0.25
        self.brightnessSlider.value = Float(self.mainScreen.brightness)
        self.brightnessSlider.addTarget(self, action: #selector(self.brightnessSliderValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(self.brightnessSlider)
        self.brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        self.brightnessSlider.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.brightnessSlider.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.brightnessSlider.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        self.brightnessSlider.heightAnchor.constraint(equalToConstant: 29).isActive = true
        
        let seperator = self.seperator
        self.view.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        seperator.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        seperator.topAnchor.constraint(equalTo: self.brightnessSlider.bottomAnchor, constant: 12).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.smallerTextButton = UIButton.init()
        self.smallerTextButton.setTitleColor(UIColor.white, for: .normal)
        self.smallerTextButton.setTitleColor(UIColor.lightGray, for: .focused)
        self.smallerTextButton.setTitle("A", for: .normal)
        self.smallerTextButton.addTarget(self, action: #selector(self.textSizeButtonPressed(_:)), for: .touchUpInside)
        self.smallerTextButton.backgroundColor = UIColor.init(red: 99/255, green: 99/255, blue: 102/255, alpha: 1.0).withAlphaComponent(0.25)
        self.smallerTextButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.smallerTextButton.layer.cornerRadius = 8
        self.smallerTextButton.layer.maskedCorners = [.layerMinXMinYCorner]
        self.view.addSubview(self.smallerTextButton)
        self.smallerTextButton.translatesAutoresizingMaskIntoConstraints = false
        self.smallerTextButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 34).isActive = true
        self.smallerTextButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -1).isActive = true
        self.smallerTextButton.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 17).isActive = true
        self.smallerTextButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        self.largerTextButton = UIButton.init()
        self.largerTextButton.setTitleColor(UIColor.white, for: .normal)
        self.largerTextButton.setTitleColor(UIColor.lightGray, for: .focused)
        self.largerTextButton.setTitle("A", for: .normal)
        self.largerTextButton.addTarget(self, action: #selector(self.textSizeButtonPressed(_:)), for: .touchUpInside)
        self.largerTextButton.backgroundColor = UIColor.init(red: 99/255, green: 99/255, blue: 102/255, alpha: 1.0).withAlphaComponent(0.25)
        self.largerTextButton.titleLabel?.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        self.largerTextButton.layer.cornerRadius = 8
        self.largerTextButton.layer.maskedCorners = [.layerMaxXMinYCorner]
        self.view.addSubview(self.largerTextButton)
        self.largerTextButton.translatesAutoresizingMaskIntoConstraints = false
        self.largerTextButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 1).isActive = true
        self.largerTextButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -34).isActive = true
        self.largerTextButton.topAnchor.constraint(equalTo: self.smallerTextButton.topAnchor).isActive = true
        self.largerTextButton.heightAnchor.constraint(equalTo: self.smallerTextButton.heightAnchor, multiplier: 1).isActive = true
        
        let themeContainer = UIView.init()
        themeContainer.backgroundColor = UIColor.init(red: 99/255, green: 99/255, blue: 102/255, alpha: 1.0).withAlphaComponent(0.25)
        themeContainer.layer.cornerRadius = 8
        themeContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.view.addSubview(themeContainer)
        themeContainer.translatesAutoresizingMaskIntoConstraints = false
        themeContainer.leadingAnchor.constraint(equalTo: self.smallerTextButton.leadingAnchor).isActive = true
        themeContainer.trailingAnchor.constraint(equalTo: self.largerTextButton.trailingAnchor).isActive = true
        themeContainer.topAnchor.constraint(equalTo: self.smallerTextButton.bottomAnchor, constant: 2).isActive = true
        themeContainer.heightAnchor.constraint(equalToConstant: 57).isActive = true
        
        var themeViews: [UIView] = []
        for (n, themeColors) in TextOptionsViewController.themes.enumerated() {
            let themeView = UIView.init()
            themeView.backgroundColor = themeColors[0]
            themeView.layer.name = "\(n)"
            themeView.layer.cornerRadius = themeViewSize.width / 2
            themeView.layer.borderWidth = 3
            themeView.layer.borderColor = themeColors[2].cgColor
            themeView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.themeViewPressed(_:))))
            let label = UILabel.init()
            label.text = "A"
            label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
            label.textColor = themeColors[1]
            themeView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: themeView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: themeView.centerYAnchor).isActive = true
            themeViews.append(themeView)
        }
        for themeView in themeViews {
            themeContainer.addSubview(themeView)
            themeView.translatesAutoresizingMaskIntoConstraints = false
            themeView.widthAnchor.constraint(equalToConstant: themeViewSize.width).isActive = true
            themeView.heightAnchor.constraint(equalToConstant: themeViewSize.height).isActive = true
            themeView.centerYAnchor.constraint(equalTo: themeContainer.centerYAnchor).isActive = true
        }
        themeViews[1].trailingAnchor.constraint(equalTo: themeContainer.centerXAnchor, constant: -5).isActive = true
        themeViews[0].trailingAnchor.constraint(equalTo: themeViews[1].leadingAnchor, constant: -10).isActive = true
        themeViews[2].leadingAnchor.constraint(equalTo: themeContainer.centerXAnchor, constant: 5).isActive = true
        themeViews[3].leadingAnchor.constraint(equalTo: themeViews[2].trailingAnchor, constant: 10).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            UserDefaults.standard.synchronize()
        }
    }
    
    @objc private func themeViewPressed(_ sender: UITapGestureRecognizer) {
        guard let name = sender.view?.layer.name, let n = Int(name), let theme = Theme.init(rawValue: n) else { return }
        if theme != currentTheme {
            delegate?.textOptionsViewController(self, didChooseNewTheme: theme)
            currentTheme = theme
            let userDefaults = UserDefaults.standard
            userDefaults.set(theme.rawValue + 1, forKey: "reading theme")
        }
    }
    
    @objc private func textSizeButtonPressed(_ sender: UIButton) {
        if sender == self.largerTextButton {
            self.delegate?.textOptionsViewController(self, didChangeFontSizeWithDirection: 1)
        } else {
            self.delegate?.textOptionsViewController(self, didChangeFontSizeWithDirection: -1)
        }
    }
    
    @objc private func brightnessSliderValueChanged(_ sender: UISlider) {
        self.mainScreen.brightness = CGFloat(sender.value)
    }
    
    private var seperator: UIView {
        let v = UIView.init()
        v.backgroundColor = UIColor.barTintColor.withAlphaComponent(0.25)
        return v
    }
    
    static var preferredSize: CGSize {
        return CGSize.init(width: 296, height: 190)
    }
    
    private var themeViewSize: CGSize {
        return CGSize.init(width: 40, height: 40)
    }
    
    //background, text, tint
    static var themes: [[UIColor]] {
        return [
            [UIColor.white, UIColor.black, UIColor.black],
            [UIColor.init(hex: "F7F0E3"), UIColor.init(hex: "383633"), UIColor.init(hex: "B67E2E")],
            [UIColor.init(hex: "5A5A5C"), UIColor.init(hex: "B4B4B4"), UIColor.init(hex: "B4B4B4")],
            [UIColor.black, UIColor.init(hex: "CFCFCF"), UIColor.init(hex: "CFCFCF")]
        ]
    }
    
    enum Theme: Int {
        case classic = 0
        case conventional
        case gray
        case dark
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
