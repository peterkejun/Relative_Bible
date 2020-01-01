//
//  CharacterVC+Controls.swift
//  Bible
//
//  Created by Jun Ke on 9/21/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension CharacterViewController {
    
    @objc func sectionButtonPressed(_ sender: UIButton) {
        if sender == self.basicsButton {
            self.setSection(index: 0, animated: true)
            self.pageController.setPage(index: 0)
        } else if sender == self.concordance_button {
            self.setSection(index: 1, animated: true)
            self.pageController.setPage(index: 1)
        }
    }
    
}

