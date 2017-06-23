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

class NewsFeedViewController: UICollectionViewController {
    
    var viewModel: NewsFeedViewModelType!
    
    let disposeBag = DisposeBag()
    
    var refreshTrigger: Observable<Void>!
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
    }
    
    func setupRx() {
        refreshTrigger = refreshControl
            .rx
            .controlEvent(.valueChanged)
            .map { () }
        
        let articlesStream = Observable.just(())
            .concat(refreshTrigger)
            .flatMapLatest { self.viewModel.fetchArticles() }
        
        articlesStream
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView!.rx.items) { collectionView, row, article in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsFeedCellId, for: IndexPath(row: row, section: 0)) as! NewsFeedCell
                cell.viewModel = self.viewModel.createCellViewModel(from: article)
                
                return cell
            }
            .addDisposableTo(disposeBag)
    }
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 120)
    }
    
}








