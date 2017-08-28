//
//  SourceArticlesCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 8/15/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import Foundation
import RealmSwift

class SourceArticlesCoordinator: FlowCoordinator {
    
    let source: SourceObject
    let articleInteractor: ArticleInteractor
    let navigationController: UINavigationController
    
    var detailCoordinator: DetailCoordinator?
    
    init(navigationController: UINavigationController, sourceObject: SourceObject, articleInteractor: ArticleInteractor) {
        self.source = sourceObject
        self.articleInteractor = articleInteractor
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SourceArticleViewModel(sourceObject: source, articleInteractor: articleInteractor)
        viewModel.delegate = self
        
        let viewController = SourceArticlesViewController()
        viewController.viewModel = viewModel
                
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SourceArticlesCoordinator: SourceArticleViewModelDelegate {
    func sourceArticleViewModel(viewMode: SourceArticleViewModel, didSelectArticle article: ArticleObject) {
        detailCoordinator = DetailCoordinator(navigationController: navigationController, article: article)
        detailCoordinator?.start()
    }
}
