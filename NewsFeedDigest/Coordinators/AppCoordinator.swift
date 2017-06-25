//
//  AppCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

struct AppCoordinator: Coordinator {
    
    let window: UIWindow
    let navigationController: UINavigationController
    
    var newsFeedCoordinator: NewsFeedCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        
        navigationController = UINavigationController()
        
        showNewsFeed()
    }
    
    mutating func showNewsFeed() {
        newsFeedCoordinator = NewsFeedCoordinator(navigationController: navigationController)
        newsFeedCoordinator?.start()                
    }
    
    func start() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
}
