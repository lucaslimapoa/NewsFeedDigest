//
//  NewsFeedViewController.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift
import RxSwift
import RxCocoa
import Nuke

let NewsFeedCellId = "NewsFeedCellId"

protocol NewsFeedViewControllerProtocol: class {
    
}

class NewsFeedViewController: UICollectionViewController, NewsFeedViewControllerProtocol {
    
    var viewModel: NewsFeedViewModelProtocol!
    
    let disposeBag = DisposeBag()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.dataSource = nil
        collectionView!.backgroundColor = Colors.collectionViewBackgroundColor
        collectionView!.register(NewsFeedCell.self, forCellWithReuseIdentifier: NewsFeedCellId)
        
        collectionView!.contentInset.top = 10
        collectionView!.contentInset.bottom = 10
        
        refreshControl = UIRefreshControl()
        collectionView!.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}








