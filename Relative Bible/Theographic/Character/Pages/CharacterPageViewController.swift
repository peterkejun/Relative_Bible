//
//  CharacterViewController.swift
//  Bible
//
//  Created by Jun Ke on 9/21/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class CharacterPageViewController: UIPageViewController {
    
    var basicsVC: CharacterBasicsViewController!
    var concordance_view_controller: CharacterConcordanceViewController!
    
    var characterID: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.dataSource = self
        
        self.basicsVC = CharacterBasicsViewController.init()
        self.basicsVC.characterID = self.characterID
        self.concordance_view_controller = CharacterConcordanceViewController.init()
        self.concordance_view_controller.character_id = self.characterID
        self.setViewControllers([self.basicsVC], direction: .forward, animated: false, completion: nil)
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
