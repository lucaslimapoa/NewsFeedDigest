//
//  SourceListCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

class SourceListCoordinator: TabBarCoordinator {
    
    var rootViewController: UINavigationController
    var tabBarItem: UITabBarItem
    
    init() {
        tabBarItem = UITabBarItem(title: "Sources", image: nil, selectedImage: nil)
        rootViewController = UINavigationController()
        rootViewController.tabBarItem = tabBarItem
        
        let sourceListViewController = createSourceListViewController()
        
        rootViewController.viewControllers = [sourceListViewController]
    }
    
    func createSourceListViewController() -> SourceListViewController {
        let sourceListViewController = SourceListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        return sourceListViewController
    }
    
}
