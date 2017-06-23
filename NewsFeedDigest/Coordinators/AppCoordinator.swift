//
//  AppCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    let navigationController: UINavigationController
    let rootViewController: NewsFeedViewController
    
    private(set) var children = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
        
        let userStore = UserStore()
        let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24")
        let viewModel = NewsFeedViewModel(userStore: userStore, newsAPIClient: newsAPI)
        
        rootViewController = NewsFeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        rootViewController.viewModel = viewModel
        
        navigationController = UINavigationController(rootViewController: rootViewController)
    }
    
    func start() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
}
