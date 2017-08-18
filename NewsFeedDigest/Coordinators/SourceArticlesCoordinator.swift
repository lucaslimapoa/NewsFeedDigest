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
    
    init(navigationController: UINavigationController, sourceObject: SourceObject, articleInteractor: ArticleInteractor) {
        self.source = sourceObject
        self.articleInteractor = articleInteractor
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = SourceArticlesViewController()        
        navigationController.pushViewController(viewController, animated: true)
    }
}
