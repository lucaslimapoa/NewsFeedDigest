//
//  AppCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import RealmSwift
import NewsAPISwift

class AppCoordinator: FlowCoordinator {
    
    private let window: UIWindow
    private let tabBarController: UITabBarController
    
    fileprivate let realm: Realm
    fileprivate var coordinators: [TabBarCoordinator] = []
    fileprivate let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24")
    
    init(window: UIWindow) {
        self.window = window
        
        do {
            realm = try Realm()
        } catch let error {
            fatalError("\(error.localizedDescription)")
        }
        
        tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = Colors.appTint
        
        createCoordinators()
        
        tabBarController.viewControllers = coordinators.map{ $0.rootViewController }
    }
    
    func start() {
        self.window.rootViewController = tabBarController
        self.window.makeKeyAndVisible()
    }
    
    func cleanStorage() {
        try? realm.write {
            let articles = realm.objects(ArticleObject.self)
            realm.delete(articles)
        }
    }
}

private extension AppCoordinator {
    func createCoordinators() {
        coordinators.append(NewsFeedCoordinator(newsAPI: newsAPI, realm: realm))
        coordinators.append(CategoryListCoordinator(newsAPI: newsAPI, realm: realm))
    }
}
