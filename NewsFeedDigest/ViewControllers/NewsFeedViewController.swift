//
//  NewsFeedViewController.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let newsFeedCellId = "NewsFeedCellId"

protocol NewsFeedViewControllerProtocol: class {
    var refreshTrigger: Observable<Void> { get }
}

class NewsFeedViewController: UICollectionViewController, NewsFeedViewControllerProtocol {
    
    var viewModel: NewsFeedViewModelProtocol!
    
    let disposeBag = DisposeBag()
    var refreshControl: UIRefreshControl!
    
    var refreshTrigger: Observable<Void> {
        return refreshControl
            .rx
            .controlEvent(.valueChanged)
            .map { [refreshControl] in
                return refreshControl?.isRefreshing
            }
            .filter { $0 == true }
            .map { _ in return () }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = Colors.collectionViewBackgroundColor
        collectionView?.register(NewsFeedCell.self, forCellWithReuseIdentifier: newsFeedCellId)
        
        refreshControl = UIRefreshControl()
        collectionView?.addSubview(refreshControl)
        
        setupRx()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchArticles()
    }
    
    func setupRx() {
        _ = viewModel.articles
            .asObservable()
            .observeOn(MainScheduler.instance)
            .filter { $0.count > 0 }
            .map { articles in
                print(articles)
            }
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
}
