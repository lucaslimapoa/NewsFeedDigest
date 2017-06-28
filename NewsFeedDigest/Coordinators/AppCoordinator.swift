//
//  AppCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

class AppCoordinator: FlowCoordinator {
    
    let window: UIWindow
    let tabBarController: UITabBarController
    let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24")
    
    var coordinators: [TabBarCoordinator] = []
    
    init(window: UIWindow) {
        self.window = window
        
        tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = Colors.appTint
//        tabBarController.tabBar.itemPositioning = UITabBarItemPositioning.centered
        
        createCoordinators()
        
        tabBarController.viewControllers = coordinators.map{ $0.rootViewController }
    }
    
    func createCoordinators() {
        coordinators.append(NewsFeedCoordinator(newsAPI: newsAPI))
        coordinators.append(CategoryListCoordinator(newsAPI: newsAPI))
    }
    
    func start() {
        self.window.rootViewController = tabBarController
        self.window.makeKeyAndVisible()
    }
}
