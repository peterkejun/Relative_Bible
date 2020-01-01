//
//  TabBarController.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let homeVC = HomeViewController.init()
        homeVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 0)
        
        let readVC = ReadViewController.init()
        readVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 1)
        
        let familyTreeVC = FamilyTreeViewController.init()
        familyTreeVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .more, tag: 2)
        
        let viewControllersList = [homeVC, readVC, familyTreeVC]
        self.viewControllers = viewControllersList.map { UINavigationController(rootViewController: $0) }
    }
    
    func showHideTabBar() {
        if self.tabBar.frame.origin.y == self.view.frame.size.height - self.tabBar.frame.size.height {
            self.hideTabBar()
        } else {
            self.showTabBar()
        }
    }
    
    private func hideTabBar() {
        var frame = self.tabBar.frame
        frame.origin.y = self.view.frame.size.height + frame.size.height
        UIView.animate(withDuration: 0.3, animations: {
            self.tabBar.frame = frame
        })
    }
    
    private func showTabBar() {
        var frame = self.tabBar.frame
        frame.origin.y = self.view.frame.size.height - frame.size.height
        UIView.animate(withDuration: 0.3, animations: {
            self.tabBar.frame = frame
        })
    }
    
}

