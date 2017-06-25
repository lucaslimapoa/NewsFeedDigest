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

class NewsFeedCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    var detailCoordinator: DetailCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let userStore = FakeUserStore()
        let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24")
        
        let viewModel = NewsFeedViewModel(userStore: userStore, newsAPIClient: newsAPI)
        viewModel.coordinatorDelegate = self
        
        let newsFeedViewController = NewsFeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        newsFeedViewController.viewModel = viewModel
        
        navigationController.pushViewController(newsFeedViewController, animated: true)
    }
}

extension NewsFeedCoordinator: NewsFeedViewModelCoordinatorDelegate {
    func newsFeedViewModelDidSelectArticle(viewModel: NewsFeedViewModelType, article: NewsAPIArticle) {
        detailCoordinator = DetailCoordinator(navigationController: navigationController, article: article)
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
