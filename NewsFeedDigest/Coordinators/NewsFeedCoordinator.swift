//
//  NewsFeedCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

struct NewsFeedCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let newsFeedViewController: NewsFeedViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let userStore = FakeUserStore()
        let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24")
        let viewModel = NewsFeedViewModel(userStore: userStore, newsAPIClient: newsAPI)
        
        newsFeedViewController = NewsFeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        newsFeedViewController.viewModel = viewModel
    }
    
    func start() {
        navigationController.pushViewController(newsFeedViewController, animated: true)
    }
}
