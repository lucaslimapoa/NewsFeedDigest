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
let BigNewsFeedCellId = "BigNewsFeedCellId"

class NewsFeedViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    var tableViewHeader: NewsFeedTableViewHeader!
    
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
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        tableView.dataSource = nil
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.collectionViewBackgroundColor
        
        tableView.register(NewsFeedCell.self, forCellReuseIdentifier: NewsFeedCellId)
        tableView.register(BigNewsFeedCell.self, forCellReuseIdentifier: BigNewsFeedCellId)
        
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 10
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl!)
        
        addHeader()
        setupStatusBar()
        
        setupRx()
        refreshTrigger.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewHeader.updateMessage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupStatusBar() {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = .white
        }
    }
    
    private func addHeader() {
        guard let view = R.nib.newsFeedTableViewHeader.firstView(owner: self) else { return }
        
        let height = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var headerFrame = view.frame
        
        if headerFrame.height != height {
            headerFrame.size.height = height + 10
            view.frame = headerFrame
        }
        
        tableViewHeader = view
        tableView.tableHeaderView = tableViewHeader
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 0) ? 350.0 : 120.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = R.nib.newsFeedSectionHeader.firstView(owner: self) else { return nil }

        let color = dataSource.sectionModels[section].color
        let sourceName = dataSource.sectionModels[section].header
        
        view.titleLabel.textColor = color
        view.titleLabel.text = sourceName
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = R.nib.newsFeedSectionFooter.firstView(owner: self) else { return nil }
        
        let sourceName = dataSource.sectionModels[section].header.localizedUppercase
        let color = dataSource.sectionModels[section].color
        
        let attributedText = NSMutableAttributedString(string: "MORE STORIES FROM ", attributes: [
            NSFontAttributeName: Fonts.footerText,
            NSForegroundColorAttributeName: Colors.footerText
            ])
        
        attributedText.append(NSAttributedString(string: sourceName, attributes: [
            NSFontAttributeName: Fonts.footerText,
            NSForegroundColorAttributeName: color
            ]))
        
        view.textLabel.attributedText = attributedText
        
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
            let cell = (indexPath.row == 0) ?
                tableView.dequeueReusableCell(withIdentifier: BigNewsFeedCellId, for: indexPath) as! BigNewsFeedCell : tableView.dequeueReusableCell(withIdentifier: NewsFeedCellId, for: indexPath) as! NewsFeedCell
            
            cell.viewModel = self.viewModel.createCellViewModel(from: item)
            
            return cell
        }

        return dataSource
    }
    
}



