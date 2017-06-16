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
        
        setupRx()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchArticles()
    }
    
    func setupRx() {
        viewModel.articles
            .asDriver()
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView!.rx.items(dataSource: self))
            .addDisposableTo(disposeBag)
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .map { _ in
                let isRefreshing = self.refreshControl.isRefreshing
                return isRefreshing
            }
            .filter { $0 == true }
            .subscribe(onNext: { _ in
                self.viewModel.fetchArticles()
            })
            .addDisposableTo(disposeBag)
    }
}

extension NewsFeedViewController: RxCollectionViewDataSourceType {
    typealias Element = [NewsAPIArticle]
    
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) -> Void {
        if case .next(let articles) = observedEvent {
            if articles.count > 0 {
                refreshControl.endRefreshing()
                collectionView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.articles.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsFeedCellId, for: indexPath) as! NewsFeedCell
        let article = viewModel.articles.value[indexPath.item]
        
        if let attributedDescription = article.attributedDescription, let imageUrl = article.urlToImage, let publishedAt = article.publishedAt, let sourceId = article.sourceId {
            cell.imageView.image = nil
            Nuke.loadImage(with: imageUrl, into: cell.imageView)
            
            cell.contentDescription.attributedText = attributedDescription
            cell.informationText.text = viewModel.convertToInformationText(sourceId: sourceId, publishedAt: publishedAt)
        }
        
        return cell
    }
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 100)
    }
}










