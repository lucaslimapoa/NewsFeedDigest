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
import NewsAPISwift

let NewsFeedCellId = "NewsFeedCellId"

class NewsFeedViewController: UITableViewController {
    
    var viewModel: NewsFeedViewModelType!
    
    let disposeBag = DisposeBag()
    
    var refreshTrigger: Observable<Void>!
//    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView!.dataSource = nil
        tableView!.backgroundColor = Colors.collectionViewBackgroundColor
//        tableView!.register(NewsFeedCell.self, forCellWithReuseIdentifier: NewsFeedCellId)
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: NewsFeedCellId)
        
        tableView!.contentInset.top = 10
        tableView!.contentInset.bottom = 10
        
        refreshControl = UIRefreshControl()
        tableView!.addSubview(refreshControl!)
        
        setupRx()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupRx() {
        refreshTrigger = refreshControl!
            .rx
            .controlEvent(.valueChanged)
            .map { () }
        
        let articlesStream = Observable.just(())
            .concat(refreshTrigger)
            .flatMapLatest { self.viewModel.fetchArticles() }
        
        articlesStream
            .do(onNext: { _ in
                self.refreshControl!.endRefreshing()
            })
            .asDriver(onErrorJustReturn: [])
            .drive(tableView!.rx.items) { tableView, row, article in
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsFeedCellId, for: IndexPath(row: row, section: 0)) as! NewsFeedCell
//                cell.viewModel = self.viewModel.createCellViewModel(from: article)

                let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCellId, for: IndexPath(row: row, section: 0))
                
                cell.textLabel?.text = article.title!
                
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView!.rx
            .modelSelected(NewsAPIArticle.self)
            .bind(to: viewModel.selectedItemListener)
            .disposed(by: disposeBag)
    }
}






