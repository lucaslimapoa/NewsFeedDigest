//
//  SourceArticlesViewController.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 8/17/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift
import RxSwift
import RxCocoa

fileprivate let tabBarHeight: CGFloat = 49.0
fileprivate let navigationBarHeight: CGFloat = 64.0
fileprivate let cellId = "NewsFeedCellId"

class SourceArticlesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var viewModel: SourceArticleViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 120.0
        tableView.register(NewsFeedCell.self, forCellReuseIdentifier: cellId)
        
        setupNavigatonBar()
        setupRx()
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupNavigatonBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupRx() {
        viewModel
            .fetchTitle()
            .subscribe(onNext: { [weak self] title in
                self?.navigationItem.title = title
            })
            .disposed(by: disposeBag)
        
        viewModel
            .fetchArticles()
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: NewsFeedCell.self)) { _, item, cell in
                cell.viewModel = self.viewModel.createCellViewModel(from: item)
            }
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(ArticleObject.self)
            .bind(to: viewModel.selectedItemListener)
            .disposed(by: disposeBag)
    }
}

extension SourceArticlesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SourceArticlesViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location), let articleObject = viewModel.fetchArticle(indexPath: indexPath) else { return nil }
        return DetailCoordinator.createPreview(url: articleObject.url)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        showDetailViewController(viewControllerToCommit, sender: self)
    }
    
}
