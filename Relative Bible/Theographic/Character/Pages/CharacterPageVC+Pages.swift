//
//  CharacterPageVC+Pages.swift
//  Bible
//
//  Created by Jun Ke on 9/21/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

extension CharacterPageViewController: UIPageViewControllerDataSource {
    
    func setPage(index: Int) {
        if index == 0 {
            self.setViewControllers([self.basicsVC], direction: .reverse, animated: true, completion: nil)
        } else if index == 1 {
            if self.viewControllers == [self.basicsVC] {
                self.setViewControllers([self.concordance_view_controller], direction: .forward, animated: true, completion: nil)
            } else {
                self.setViewControllers([self.concordance_view_controller], direction: .reverse, animated: true, completion: nil)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == self.basicsVC {
            return nil
        } else if viewController == self.concordance_view_controller {
            return self.basicsVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == self.basicsVC {
            return self.concordance_view_controller
        } else if viewController == self.concordance_view_controller {
            return nil
        }
        return nil
    }
    
}

