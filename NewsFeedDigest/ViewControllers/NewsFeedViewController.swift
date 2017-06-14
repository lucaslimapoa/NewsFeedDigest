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
import Nuke

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
        
        collectionView?.contentInset.top = 10
        collectionView?.contentInset.bottom = 10
        
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
                self.collectionView?.reloadData()
            }
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.articles.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsFeedCellId, for: indexPath) as! NewsFeedCell
        let article = viewModel.getItem(for: indexPath)
        
        if let attributedDescription = article.attributedDescription, let imageUrl = article.urlToImage, let publishedAt = article.publishedAt {
            cell.imageView.image = nil
            Nuke.loadImage(with: imageUrl, into: cell.imageView)
            
            cell.contentDescription.attributedText = attributedDescription
            cell.informationText.text = "The Verge / \(publishedAt)"
        }
        
        return cell
    }
    
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 100)
    }
    
}










