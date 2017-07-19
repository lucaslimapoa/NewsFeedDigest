//
//  NewsFeedCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import RealmSwift
import NewsAPISwift

class NewsFeedCoordinator: TabBarCoordinator {
    
    var tabBarItem: UITabBarItem
    var rootViewController: UINavigationController
    
    var detailCoordinator: DetailCoordinator?
    
    let newsAPI: NewsAPIProtocol
    let realm: Realm
    
    init(newsAPI: NewsAPIProtocol, realm: Realm) {
        self.newsAPI = newsAPI
        self.realm = realm
        
        tabBarItem = UITabBarItem(title: "For You", image: nil, selectedImage: nil)
        
        rootViewController = UINavigationController()
        rootViewController.tabBarItem = tabBarItem
        rootViewController.navigationBar.backgroundColor = .white
        
        let newsFeedViewController = createNewsFeedViewController()
        
        rootViewController.viewControllers = [newsFeedViewController]
    }
    
    private func createNewsFeedViewController() -> NewsFeedViewController {
        let userStore = FakeUserStore()
        
        let dateConversor = DateConversor(currentDate: Date())
        let articleInteractor = ArticleInteractor(newsAPI: newsAPI, realm: realm, dateConversor: dateConversor)
        let sourceInteractor = SourceInteractor(realm: realm, newsAPI: newsAPI)        
        
        let viewModel = NewsFeedViewModel(userStore: userStore, articleInteractor: articleInteractor, sourceInteractor: sourceInteractor)
        
        viewModel.coordinatorDelegate = self
        
        let newsFeedViewController = NewsFeedViewController()
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
