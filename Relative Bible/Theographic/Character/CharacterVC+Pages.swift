//
//  CharacterVC+Pages.swift
//  Bible
//
//  Created by Jun Ke on 9/21/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension CharacterViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = previousViewControllers.first else { return }
        if !completed {
            if viewController is CharacterBasicsViewController {
                self.setSection(index: 0, animated: true)
            } else if viewController is CharacterConcordanceViewController {
                self.setSection(index: 1, animated: true)
            }
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let viewController = pendingViewControllers.first else { return }
        if viewController is CharacterBasicsViewController {
            self.setSection(index: 0, animated: true)
        } else if viewController is CharacterConcordanceViewController {
            self.setSection(index: 1, animated: true)
        }
    }
    
}

