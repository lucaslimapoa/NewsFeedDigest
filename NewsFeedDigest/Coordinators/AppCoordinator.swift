//
//  AppCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    let tabBarController: UITabBarController
    
    var coordinators: [TabBarCoordinator] = []
    
    init(window: UIWindow) {
        self.window = window
        
        tabBarController = UITabBarController()
        
        createCoordinators()
        
        tabBarController.viewControllers = coordinators.map{ $0.rootViewController }
    }
    
    func createCoordinators() {
        coordinators.append(NewsFeedCoordinator())
        coordinators.append(SourceListCoordinator())
    }
    
    func start() {
        self.window.rootViewController = tabBarController
        self.window.makeKeyAndVisible()
    }
}
