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
import NewsAPISwift

let NewsFeedCellId = "NewsFeedCellId"
let BigNewsFeedCellId = "BigNewsFeedCellId"

class NewsFeedViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    var emptyMessageView: UIView!
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
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = Colors.collectionViewBackgroundColor
        
        tableView.register(NewsFeedCell.self, forCellReuseIdentifier: NewsFeedCellId)
        tableView.register(BigNewsFeedCell.self, forCellReuseIdentifier: BigNewsFeedCellId)
        
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 10
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl!)
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        setupEmptySourcesMessage()
        setupRx()
        
        refreshTrigger.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setStatusBar(color: .clear)
    }
    
    private func setStatusBar(color: UIColor) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = color
        }
    }
    
    func setupEmptySourcesMessage() {
        guard let messageView = R.nib.emptySourcesMessage.firstView(owner: self) else { fatalError("Cannot open EmptysourcesMessage view") }
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyMessageView = messageView
        view.addSubview(emptyMessageView)
        
        emptyMessageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyMessageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyMessageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
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
        let sourceId = dataSource.sectionModels[section].sourceId
        
        let attributedText = NSMutableAttributedString(string: "MORE STORIES FROM ", attributes: [
            NSFontAttributeName: Fonts.footerText,
            NSForegroundColorAttributeName: Colors.footerText
            ])
        
        attributedText.append(NSAttributedString(string: sourceName, attributes: [
            NSFontAttributeName: Fonts.footerText,
            NSForegroundColorAttributeName: color
            ]))
        
        view.delegate = self
        view.sourceId = sourceId
        view.textLabel.attributedText = attributedText
        view.separatorView.isHidden = (dataSource.sectionModels.count - 1 == section)
        
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
                self.emptyMessageView.isHidden = true
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.articleSections
            .asObservable()
            .filter { $0.count == 0 }
            .subscribe(onNext: { _ in
                self.emptyMessageView.isHidden = false
            })
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

extension NewsFeedViewController: NewsFeedSectionFooterViewDelegate {
    
    func newsFeedSectionFooterView(_ footerView: NewsFeedSectionFooterView, didSelectSource source: SourceId) {
        viewModel.selectedSourceListener.onNext(source)
    }
    
}

extension NewsFeedViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        let articleObject = dataSource.sectionModels[indexPath.section].items[indexPath.row]
        let detailViewController = DetailCoordinator.createPreview(url: articleObject.url)
        
        return detailViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        showDetailViewController(viewControllerToCommit, sender: self)
    }
    
}

