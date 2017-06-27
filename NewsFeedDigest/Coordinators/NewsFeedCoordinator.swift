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
    func newsFeedViewModel(viewModel: NewsFeedViewModelType, didSelectArticle article: NewsAPIArticle)
}

class NewsFeedCoordinator: TabBarCoordinator {
    
    var tabBarItem: UITabBarItem
    var rootViewController: UINavigationController
    
    var detailCoordinator: DetailCoordinator?
    
    let newsAPI: NewsAPIProtocol
    
    init(newsAPI: NewsAPIProtocol) {
        self.newsAPI = newsAPI
        
        tabBarItem = UITabBarItem(title: "Feed", image: nil, selectedImage: nil)
        
        rootViewController = UINavigationController()
        rootViewController.tabBarItem = tabBarItem
        rootViewController.navigationBar.backgroundColor = .white
        
        let newsFeedViewController = createNewsFeedViewController()
        
        rootViewController.viewControllers = [newsFeedViewController]
    }
    
    private func createNewsFeedViewController() -> NewsFeedViewController {
        let userStore = FakeUserStore()
        
        let viewModel = NewsFeedViewModel(userStore: userStore, newsAPIClient: newsAPI)
        viewModel.coordinatorDelegate = self
        
        let newsFeedViewController = NewsFeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        newsFeedViewController.viewModel = viewModel
        
        return newsFeedViewController
    }
}

extension NewsFeedCoordinator: NewsFeedViewModelCoordinatorDelegate {
    func newsFeedViewModel(viewModel: NewsFeedViewModelType, didSelectArticle article: NewsAPIArticle) {
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
