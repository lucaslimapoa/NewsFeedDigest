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
import RxDataSources

let NewsFeedCellId = "NewsFeedCellId"

class NewsFeedViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    var viewModel: NewsFeedViewModelType!
    var refreshTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.backgroundColor = Colors.collectionViewBackgroundColor
        
        tableView.register(NewsFeedCell.self, forCellReuseIdentifier: NewsFeedCellId)
        
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 10
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl!)
        
        setupRx()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTrigger.onNext(())
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}

private extension NewsFeedViewController {
    
    func setupRx() {        
        let refreshControlStream = refreshControl!
            .rx
            .controlEvent(.valueChanged)
            .map { () }
        
        Observable.of(refreshControlStream, refreshTrigger.asObservable())
            .merge()
            .do(onNext: { _ in
                self.refreshControl?.endRefreshing()
            })
            .subscribe(onNext: { _ in
                self.viewModel.fetchArticles()
            })
            .disposed(by: disposeBag)
        
        let dataSource = createDataSource()
        
        viewModel.articleSections
            .asObservable()
            .do(onNext: { _ in
                self.refreshControl?.endRefreshing()
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(ArticleObject.self)
            .bind(to: viewModel.selectedItemListener)
            .disposed(by: disposeBag)
    }
    
    func createDataSource() -> RxTableViewSectionedReloadDataSource<ArticleSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<ArticleSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCellId, for: indexPath) as! NewsFeedCell
            
            cell.viewModel = self.viewModel.createCellViewModel(from: item)
            
            return cell
        }
        
        return dataSource
    }
    
}



