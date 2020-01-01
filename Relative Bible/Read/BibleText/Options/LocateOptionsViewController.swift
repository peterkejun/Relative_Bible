//
//  LocateOptionsViewController.swift
//  Bible
//
//  Created by Jun Ke on 8/5/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol LocateOptionsViewControllerDelegate: class {
    func locateOptionsViewController(_ viewController: LocateOptionsViewController, didEndSliderActionWithValue value: Float)
    var textForTitleLabel: String { get }
    var numberOfUnits: Int { get }
    func text(forSliderValue value: Float) -> String
}

class LocateOptionsViewController: UIViewController {
    
    weak var delegate: LocateOptionsViewControllerDelegate?
    
    var jumpLabel: UILabel!
    var locateSlider: UISlider!
    var verseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0)
        
        self.jumpLabel = UILabel.init()
        self.jumpLabel.text = "Jumping to"
        self.jumpLabel.textColor = UIColor.white
        self.jumpLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        self.view.addSubview(self.jumpLabel)
        self.jumpLabel.translatesAutoresizingMaskIntoConstraints = false
        self.jumpLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        self.jumpLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        self.verseLabel = UILabel.init()
        self.verseLabel.text = "Try the slider"
        self.verseLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.verseLabel.textColor = UIColor.white
        self.view.addSubview(verseLabel)
        self.verseLabel.translatesAutoresizingMaskIntoConstraints = false
        self.verseLabel.topAnchor.constraint(equalTo: self.jumpLabel.bottomAnchor, constant: 8).isActive = true
        self.verseLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        let seperator = self.seperator
        self.view.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        seperator.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        seperator.topAnchor.constraint(equalTo: self.verseLabel.bottomAnchor, constant: 10).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.locateSlider = UISlider.init()
        self.locateSlider.maximumTrackTintColor = UIColor.init(hex: "D1D1D7").withAlphaComponent(0.25)
        self.locateSlider.minimumTrackTintColor = UIColor.white
        self.locateSlider.maximumValue = 1
        self.locateSlider.minimumValue = 0.25
        self.locateSlider.addTarget(self, action: #selector(self.locateSliderValueChanged(_:)), for: .valueChanged)
        self.locateSlider.addTarget(self, action: #selector(self.locateSliderTouchUp(_:)), for: .touchUpInside)
        self.locateSlider.addTarget(self, action: #selector(self.locateSliderTouchUp(_:)), for: .touchUpOutside)
        self.view.addSubview(self.locateSlider)
        self.locateSlider.translatesAutoresizingMaskIntoConstraints = false
        self.locateSlider.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.locateSlider.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.locateSlider.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 12).isActive = true
        self.locateSlider.heightAnchor.constraint(equalToConstant: 29).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetSlider()
    }
    
    private func resetSlider() {
        self.locateSlider.minimumValue = 1
        self.locateSlider.maximumValue = Float(self.delegate?.numberOfUnits ?? 0)
    }
    
    @objc private func locateSliderValueChanged(_ sender: UISlider) {
        self.jumpLabel.text = self.delegate?.textForTitleLabel ?? "Jumping to"
        self.verseLabel.text = self.delegate?.text(forSliderValue: sender.value)
    }
    
    @objc private func locateSliderTouchUp(_ sender: UISlider) {
        self.delegate?.locateOptionsViewController(self, didEndSliderActionWithValue: sender.value)
        self.dismiss(animated: true, completion: nil)
    }
    
    private var seperator: UIView {
        let v = UIView.init()
        v.backgroundColor = UIColor.barTintColor.withAlphaComponent(0.25)
        return v
    }
    
    static var preferredSize: CGSize {
        return .init(width: 261, height: 126)
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
