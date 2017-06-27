//
//  SourceListCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

class SourceListCoordinator: TabBarCoordinator {
    
    var rootViewController: UINavigationController
    var tabBarItem: UITabBarItem
    
    let newsAPI: NewsAPIProtocol
    
    init(newsAPI: NewsAPIProtocol) {
        self.newsAPI = newsAPI
        
        tabBarItem = UITabBarItem(title: "Sources", image: nil, selectedImage: nil)
        rootViewController = UINavigationController()
        rootViewController.tabBarItem = tabBarItem
        
        let viewModel = SourceListViewModel(newsAPI: newsAPI)
        let sourceListViewController = createSourceListViewController()
        sourceListViewController.viewModel = viewModel
        
        rootViewController.viewControllers = [sourceListViewController]
    }
    
    func createSourceListViewController() -> SourceListViewController {
        let sourceListViewController = SourceListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        return sourceListViewController
    }
    
}
