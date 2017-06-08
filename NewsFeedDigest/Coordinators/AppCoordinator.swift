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
    let navigationController: UINavigationController
    let rootViewController: NewsFeedViewController
    
    private(set) var children = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
        
        rootViewController = NewsFeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController = UINavigationController(rootViewController: rootViewController)
    }
    
    func start() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func stop() {
        
    }
}
