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
    
    let dispatchToken = UUID().uuidString
    let disposeBag = DisposeBag()
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
        
        tableView.delegate = self
        tableView.rowHeight = 120.0
        tableView.register(NewsFeedCell.self, forCellReuseIdentifier: cellId)
        
        setupRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLayoutSubviews() {
        DispatchQueue.once(token: dispatchToken) {
            self.tableViewInitialPos = tableView.frame.origin
        }
    }
    
    private func setupRx() {
        viewModel
            .fetchTitle()
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
                cell.separatorView.backgroundColor = Colors.separatorView
            }
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
        let newY = max(tableViewInitialPos.y - tableViewContentOffsetY, navigationBarHeight)
        tableView.frame.origin = CGPoint(x: tableViewInitialPos.x, y: newY)
        tableView.frame.size = calculateTableViewSize()
    }
    
    func animateViews() {
        let fadeOutAlpha = (self.tableView.frame.origin.y - navigationBarHeight) / (tableViewInitialPos.y - navigationBarHeight)
        
        UIView.animate(withDuration: 0.1) {
            self.titleLabel.alpha = fadeOutAlpha
            self.descriptionTextView.alpha = fadeOutAlpha
        }
    }
}

extension SourceArticlesViewController: UITableViewDelegate { }

extension SourceArticlesViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewContentOffsetY = scrollView.contentOffset.y
    }
    
}
