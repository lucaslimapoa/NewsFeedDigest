//
//  NewsFeedViewController.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

protocol NewsFeedViewControllerProtocol: class {
    
}

class NewsFeedViewController: UICollectionViewController, NewsFeedViewControllerProtocol {
    
    var viewModel: NewsFeedViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = Colors.collectionViewBackgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let _ = viewModel.requestArticles()
    }
    
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
}
