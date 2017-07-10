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
import RxDataSources

let NewsFeedCellId = "NewsFeedCellId"

class NewsFeedViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    var viewModel: NewsFeedViewModelType!
    var refreshTrigger: Observable<Void>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.backgroundColor = Colors.collectionViewBackgroundColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NewsFeedCellId)
        
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 10
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl!)
        
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
        
        let dataSource = createDataSource()

        articlesStream
            .do(onNext: { _ in
                self.refreshControl!.endRefreshing()
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView!.rx
            .modelSelected(NewsAPIArticle.self)
            .bind(to: viewModel.selectedItemListener)
            .disposed(by: disposeBag)
    }
    
    func createDataSource() -> RxTableViewSectionedReloadDataSource<ArticleSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<ArticleSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCellId, for: indexPath)
            
            cell.textLabel?.text = item.title
            
            return cell
        }
        
        return dataSource
    }
}





