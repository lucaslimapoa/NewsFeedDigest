//
//  SourceListCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import RealmSwift
import NewsAPISwift

protocol SourceListViewModelDelegate {
    func sourceListViewModel(viewModel: ListViewModel, didSelectCategory category: NewsAPISwift.Category)
}

class CategoryListCoordinator: TabBarCoordinator {
    
    var rootViewController: UINavigationController
    var tabBarItem: UITabBarItem
    
    let newsAPI: NewsAPIProtocol    
    let realm: Realm
    
    var sourceListCoordinator: SourceListCoordinator?
    
    init(newsAPI: NewsAPIProtocol, realm: Realm) {
        self.newsAPI = newsAPI
        self.realm = realm
        
        tabBarItem = UITabBarItem(title: "Favorites", image: nil, selectedImage: nil)
        rootViewController = UINavigationController()
        rootViewController.tabBarItem = tabBarItem
        
        let listViewController = createListViewController(viewDataType: .category)
        rootViewController.viewControllers = [listViewController]
    }
    
    func createListViewController(viewDataType: ViewDataType) -> ListViewController {
        let sourceListViewController = ListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        let sourceInteractor = SourceInteractor(realm: realm, newsAPI: newsAPI)
        let articleInteractor = ArticleInteractor(newsAPI: newsAPI, realm: realm, dateConversor: DateConversor(currentDate: Date()))
        
        let viewModel = ListViewModel(sourceInteractor: sourceInteractor, articleInteractor: articleInteractor)
        viewModel.delegate = self        
        
        sourceListViewController.viewModel = viewModel
        sourceListViewController.viewDataType = .category
        
        return sourceListViewController
    }
    
}

extension CategoryListCoordinator: SourceListViewModelDelegate {
    
    func sourceListViewModel(viewModel: ListViewModel, didSelectCategory category: NewsAPISwift.Category) {
        sourceListCoordinator = SourceListCoordinator(viewModel: viewModel, navigationController: self.rootViewController, viewDataType: .source(category))
        sourceListCoordinator?.start()
    }
}
