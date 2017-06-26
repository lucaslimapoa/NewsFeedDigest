//
//  CoordinatorProtocol.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

protocol Coordinator {        
    func start()
}

protocol TabBarCoordinator {
    var rootViewController: UINavigationController { get }
    var tabBarItem: UITabBarItem { get }
}
