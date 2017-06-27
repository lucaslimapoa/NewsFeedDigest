//
//  SourceListCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

protocol SourceListViewModelDelegate {
    func sourceListViewModel(viewModel: SourceListViewModel, didSelectCategory category: NewsAPISwift.Category)
}

class CategoryListCoordinator: TabBarCoordinator {
    
    var rootViewController: UINavigationController
    var tabBarItem: UITabBarItem
    
    let newsAPI: NewsAPIProtocol
    
    init(newsAPI: NewsAPIProtocol) {
        self.newsAPI = newsAPI
        
        tabBarItem = UITabBarItem(title: "Sources", image: nil, selectedImage: nil)
        rootViewController = UINavigationController()
        rootViewController.tabBarItem = tabBarItem
        
        let sourceListViewController = createSourceListViewController(viewDataType: .category)
        rootViewController.viewControllers = [sourceListViewController]
    }
    
    func createSourceListViewController(viewDataType: ViewDataType) -> SourceListViewController {
        let sourceListViewController = SourceListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        let viewModel = SourceListViewModel(newsAPI: newsAPI)
        viewModel.delegate = self
        
        sourceListViewController.viewModel = viewModel
        sourceListViewController.viewDataType = .category
        
        return sourceListViewController
    }
    
}

class SourceListCoordinator: FlowCoordinator {
    
    let viewModel: SourceListViewModelType
    let navigationController: UINavigationController
    let viewDataType: ViewDataType
    
    init(viewModel: SourceListViewModelType, navigationController: UINavigationController, viewDataType: ViewDataType) {
        self.viewModel = viewModel
        self.navigationController = navigationController
        self.viewDataType = viewDataType
    }
    
    func start() {
        let sourceListViewController = SourceListViewController(collectionViewLayout: UICollectionViewLayout())
        sourceListViewController.viewModel = viewModel
        sourceListViewController.viewDataType = viewDataType
        
        navigationController.pushViewController(sourceListViewController, animated: true)
    }
}

extension CategoryListCoordinator: SourceListViewModelDelegate {
    
    func sourceListViewModel(viewModel: SourceListViewModel, didSelectCategory category: NewsAPISwift.Category) {
        let sourceListCoordinator = SourceListCoordinator(viewModel: viewModel, navigationController: self.rootViewController, viewDataType: .source(category))
        
        sourceListCoordinator.start()
    }
}
