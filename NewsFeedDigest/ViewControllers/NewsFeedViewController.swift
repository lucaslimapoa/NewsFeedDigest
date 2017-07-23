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
    
    var dataSource: RxTableViewSectionedReloadDataSource<ArticleSection>!
    
    override init(style: UITableViewStyle = .grouped) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not implemented")
    }
    
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
        refreshTrigger.onNext(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("NewsFeedSectionHeader", owner: self, options: nil)?.first as! NewsFeedSectionHeaderView    
        
        let headerTitle = dataSource.sectionModels[section].header
        view.titleLabel.text = headerTitle
        
        return view
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
        
        dataSource = createDataSource()
        
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
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        return dataSource
    }
    
}



