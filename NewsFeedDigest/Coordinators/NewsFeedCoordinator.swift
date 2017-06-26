//
//  NewsFeedCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

protocol NewsFeedViewModelCoordinatorDelegate {
    func newsFeedViewModelDidSelectArticle(viewModel: NewsFeedViewModelType, article: NewsAPIArticle)
}

class NewsFeedCoordinator: TabBarCoordinator {
    
    var tabBarItem: UITabBarItem
    var rootViewController: UINavigationController
    
    var detailCoordinator: DetailCoordinator?
    
    init() {
        tabBarItem = UITabBarItem(title: "News Feed", image: nil, selectedImage: nil)
        
        rootViewController = UINavigationController()
        rootViewController.tabBarItem = tabBarItem
        
        let newsFeedViewController = createNewsFeedViewController()
        
        rootViewController.viewControllers = [newsFeedViewController]
    }
    
    private func createNewsFeedViewController() -> NewsFeedViewController {
        let userStore = FakeUserStore()
        let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24")
        
        let viewModel = NewsFeedViewModel(userStore: userStore, newsAPIClient: newsAPI)
        viewModel.coordinatorDelegate = self
        
        let newsFeedViewController = NewsFeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        newsFeedViewController.viewModel = viewModel
        
        return newsFeedViewController
    }
}

extension NewsFeedCoordinator: NewsFeedViewModelCoordinatorDelegate {
    func newsFeedViewModelDidSelectArticle(viewModel: NewsFeedViewModelType, article: NewsAPIArticle) {
        detailCoordinator = DetailCoordinator(navigationController: rootViewController, article: article)
        detailCoordinator?.start()
    }
}

extension NewsFeedCoordinator: DetailCoordinatorDelegate {
    func detailCoordinatorDidFinish(_ coordinator: DetailCoordinator) {
        self.detailCoordinator = nil        
    }
    
    func detailCoordinatorDidFail(_ coordinator: DetailCoordinator, error: DetailCoordinatorError) {
        self.detailCoordinator = nil
        // Todo: Present error message
    }
}
