//
//  SourceListCoordinator.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/27/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

class SourceListCoordinator: FlowCoordinator {
    
    let viewModel: ListViewModelType
    let navigationController: UINavigationController
    let viewDataType: ViewDataType
    
    init(viewModel: ListViewModelType, navigationController: UINavigationController, viewDataType: ViewDataType) {
        self.viewModel = viewModel
        self.navigationController = navigationController
        self.viewDataType = viewDataType
    }
    
    func start() {
        let listViewController = ListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        listViewController.viewModel = viewModel
        listViewController.viewDataType = viewDataType
        
        navigationController.pushViewController(listViewController, animated: true)
    }
}
