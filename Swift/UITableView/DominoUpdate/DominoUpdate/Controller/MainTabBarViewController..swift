//
//  MainTabBarControllerViewController.swift
//  DominoUpdate
//
//  Created by 양중창 on 2020/01/29.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let sectionVC = UINavigationController(rootViewController: SectionViewController())
        let wishListVC = UINavigationController(rootViewController: WishListViewController())
        let categoryVC = UINavigationController(rootViewController: CategoryTableViewController())
        let jsonVC = UINavigationController(rootViewController: JsonViewController())
        
        jsonVC.tabBarItem = UITabBarItem(title: "Json", image: nil, tag: 0)
        categoryVC.tabBarItem = UITabBarItem(title: "Category", image: nil, tag: 0)
        sectionVC.tabBarItem = UITabBarItem(title: "Section", image: nil, tag: 0)
        wishListVC.tabBarItem = UITabBarItem(title: "WishList", image: nil, tag: 0)
        viewControllers = [categoryVC, sectionVC, jsonVC, wishListVC]
        
        
    }
    

}
