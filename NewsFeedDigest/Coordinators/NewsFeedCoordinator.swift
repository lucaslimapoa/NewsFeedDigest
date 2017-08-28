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
    var sourceArticlesCoordinator: SourceArticlesCoordinator?
    
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
        let dateConversor = DateConversor(currentDate: Date())
        let articleInteractor = ArticleInteractor(newsAPI: newsAPI, realm: realm, dateConversor: dateConversor)
        let sourceInteractor = SourceInteractor(realm: realm, newsAPI: newsAPI)        
        
        let viewModel = NewsFeedViewModel(articleInteractor: articleInteractor, sourceInteractor: sourceInteractor)
        
        viewModel.delegate = self
        
        let newsFeedViewController = NewsFeedViewController()
        newsFeedViewController.viewModel = viewModel
        
        return newsFeedViewController
    }
}

extension NewsFeedCoordinator: NewsFeedViewModelDelegate {
    func newsFeedViewModel(viewModel: NewsFeedViewModelType, didSelectArticle article: ArticleObject) {
        detailCoordinator = DetailCoordinator(navigationController: rootViewController, article: article)
        detailCoordinator?.start()
    }
    
    func newsFeedViewModel(viewModel: NewsFeedViewModelType, didSelectSource source: SourceObject) {
        let dateConversor = DateConversor(currentDate: Date())
        let articleInteractor = ArticleInteractor(newsAPI: newsAPI, realm: realm, dateConversor: dateConversor)
        
        sourceArticlesCoordinator = SourceArticlesCoordinator(navigationController: rootViewController, sourceObject: source, articleInteractor: articleInteractor)
        sourceArticlesCoordinator?.start()
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
