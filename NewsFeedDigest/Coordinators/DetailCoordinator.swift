//
//  DetailCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

class DetailCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let article: NewsAPIArticle
    
    init(navigationController: UINavigationController, article: NewsAPIArticle) {
        self.navigationController = navigationController
        self.article = article
    }
    
    func start() {
        let viewModel = ArticleDetailViewModel()
        
        let articleDetailViewController = ArticleDetailViewController()
        articleDetailViewController.viewModel = viewModel
        
        navigationController.pushViewController(articleDetailViewController, animated: true)
    }
}
