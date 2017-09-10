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

class DetailCoordinator: NSObject, FlowCoordinator, SFSafariViewControllerDelegate {
    
    private let navigationController: UINavigationController
    private let article: ArticleObject
    
    private var coordinatorDelegate: DetailCoordinatorDelegate?
    
    init(navigationController: UINavigationController, article: ArticleObject) {
        self.navigationController = navigationController
        self.article = article
    }
    
    func start() {
        if let urlToArticle = URL(string: article.url) {
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

extension DetailCoordinator {
    
    static func createPreview(url: String) -> UIViewController? {
        guard let urlToArticle = URL(string: url) else { return nil }
        return SFSafariViewController(url: urlToArticle, entersReaderIfAvailable: true)
    }
    
}
