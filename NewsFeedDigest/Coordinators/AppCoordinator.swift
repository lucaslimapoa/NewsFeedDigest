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
    
    let window: UIWindow
    let tabBarController: UITabBarController
    let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24") 
    let realm: Realm
    
    var coordinators: [TabBarCoordinator] = []
    
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
    
    func createCoordinators() {
        coordinators.append(NewsFeedCoordinator(newsAPI: newsAPI, realm: realm))
        coordinators.append(CategoryListCoordinator(newsAPI: newsAPI, realm: realm))
    }
    
    func start() {
        self.window.rootViewController = tabBarController
        self.window.makeKeyAndVisible()
    }
}
