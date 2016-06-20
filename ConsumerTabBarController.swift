//
//  ConsumerTabBarController.swift
//  LocalFarming
//
//  Created by Chris Lu on 4/3/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import Foundation
import UIKit

class ConsumerTabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        let farmNavVC = UINavigationController()
        farmNavVC.navigationBar.barTintColor = Colors.headerFooterColor
        farmNavVC.tabBarItem = UITabBarItem(title: "Produce", image: UIImage(named: "Broccoli.png"), tag: 0)
        farmNavVC.pushViewController(FarmTableViewController(nibName: "FarmTableViewController", bundle: nil), animated: false)
        farmNavVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let profileNavVC = UINavigationController()
        profileNavVC.navigationBar.barTintColor = Colors.headerFooterColor
        profileNavVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "User.png"), tag: 1)
        profileNavVC.pushViewController(ProfileTableViewController(nibName: "ProfileTableViewController", bundle: nil), animated: false)
        let groceryNavVC = UINavigationController()
        groceryNavVC.tabBarItem = UITabBarItem(title: "Bag", image: UIImage(named: "Shopping-Bag.png"), tag: 2)
        groceryNavVC.pushViewController(GroceryBagTableViewController(nibName: "GroceryBagTableViewController", bundle: nil), animated: false)
        let VC = [farmNavVC, profileNavVC, groceryNavVC]
        self.viewControllers = VC
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState: .Selected)
        //self.tabBar.barTintColor = Colors.headerFooterColor
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}