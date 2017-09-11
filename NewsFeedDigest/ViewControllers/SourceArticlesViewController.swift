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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let disposeBag = DisposeBag()
    let tableViewDelegateOnceToken = UUID().uuidString
    let tableViewPositionOnceToken = UUID().uuidString
    
    var viewModel: SourceArticleViewModelType!
    
    var tableViewInitialPos: CGPoint = .zero
    var tableViewContentOffsetY: CGFloat = 0 {
        didSet {
            animateViews()
            updateTableView()
        }
    }
    
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
     
        DispatchQueue.once(token: tableViewDelegateOnceToken) {
            tableView
                .rx
                .setDelegate(self)
                .disposed(by: disposeBag)
        }
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.once(token: tableViewPositionOnceToken) {
            let positionY = descriptionTextView.frame.origin.y + descriptionTextView.frame.height + 8
            tableViewInitialPos = CGPoint(x: tableView.frame.origin.x, y: positionY)
            
            tableViewContentOffsetY = 0
        }
    }
    
    private func setupNavigatonBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupRx() {
        viewModel
            .fetchTitle()
            .do(onNext: { title in
                let titleLabel = UILabel()
                titleLabel.text = title
                
                self.navigationItem.titleView = titleLabel
                self.navigationItem.titleView?.alpha = 0.0
            })
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .fetchDescription()
            .bind(to: descriptionTextView.rx.text)
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

private extension SourceArticlesViewController {
    
    func calculateTableViewSize() -> CGSize {
        let screenHeight = view.frame.height
        let newTableViewHeight = screenHeight - tableView.frame.origin.y - tabBarHeight
        
        return CGSize(width: tableView.frame.width, height: newTableViewHeight)
    }
    
    func updateTableView() {
        let newY = max(tableViewInitialPos.y - tableViewContentOffsetY, 0)
        tableView.frame.origin = CGPoint(x: tableViewInitialPos.x, y: newY)
        tableView.frame.size = calculateTableViewSize()
    }
    
    func animateViews() {
        let fadeOutAlpha = tableView.frame.origin.y / tableViewInitialPos.y
        let fadeInAlpha = 1 - fadeOutAlpha
        
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = fadeOutAlpha
            self.descriptionTextView.alpha = fadeOutAlpha
            
            self.navigationItem.titleView?.alpha = fadeInAlpha
        }
    }
}

extension SourceArticlesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SourceArticlesViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewContentOffsetY = scrollView.contentOffset.y
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
