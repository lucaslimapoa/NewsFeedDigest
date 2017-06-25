//
//  DetailCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift
import SafariServices

enum DetailCoordinatorError: Error {
    case couldNotReadURL
}

protocol DetailCoordinatorDelegate {
    func detailCoordinatorDidFail(_ coordinator: DetailCoordinator, error: DetailCoordinatorError)
    func detailCoordinatorDidFinish(_ coordinator: DetailCoordinator)
}

class DetailCoordinator: NSObject, Coordinator, SFSafariViewControllerDelegate {
    
    let navigationController: UINavigationController
    let article: NewsAPIArticle
    
    var coordinatorDelegate: DetailCoordinatorDelegate?
    
    init(navigationController: UINavigationController, article: NewsAPIArticle) {
        self.navigationController = navigationController
        self.article = article
    }
    
    func start() {
        if let urlToArticle = article.url {
            let safariViewController = SFSafariViewController(url: urlToArticle, entersReaderIfAvailable: true)            
            navigationController.present(safariViewController, animated: true, completion: nil)
        } else {
            coordinatorDelegate?.detailCoordinatorDidFail(self, error: DetailCoordinatorError.couldNotReadURL)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
        coordinatorDelegate?.detailCoordinatorDidFinish(self)
    }
}
