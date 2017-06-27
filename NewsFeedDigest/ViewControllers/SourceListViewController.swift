//
//  SourceListViewController.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import RxSwift
import NewsAPISwift

private let CategoryCellId = "CategoryCellId"
private let SourceCellId = "SourceCellId"

enum ViewDataType {
    case category
    case source(NewsAPISwift.Category)
}

class SourceListViewController: UICollectionViewController {

    let disposeBag = DisposeBag()
    var viewModel: SourceListViewModelType!
    var viewDataType: ViewDataType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.backgroundColor = Colors.collectionViewBackgroundColor
     
        collectionView!.dataSource = nil
        collectionView!.contentInset = UIEdgeInsetsMake(10, 20, 10, 20)
        
        configureViewController()
    }
    
    func configureViewController() {
        switch viewDataType! {
        case .category:
            setupCategoryViewController()
            setupCategoryRx()
        case .source(let category):
            setupSourceViewController()
            setupSourceRx(category)
        }
    }
    
    func setupCategoryViewController() {
        collectionView!.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCellId)
    }

    func setupCategoryRx() {
        viewModel.fetchAvailableCategories()
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView!.rx.items) { collectionView, row, category in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCellId, for: IndexPath(row: row, section: 0)) as! CategoryCell
                
                cell.nameLabel.text = category.convert()
                cell.backgroundColor = Colors.color(for: category)
                
                return cell
            }
            .addDisposableTo(disposeBag)
        
        collectionView!
            .rx
            .modelSelected(NewsAPISwift.Category.self)
            .bind(to: viewModel.selectedCategoryListener)
            .addDisposableTo(disposeBag)
    }
    
    func setupSourceViewController() {
        collectionView!.register(SourceCell.self, forCellWithReuseIdentifier: SourceCellId)
    }
    
    func setupSourceRx(_ category: NewsAPISwift.Category) {
        viewModel.fetchSources(for: category)
            .bind(to: collectionView!.rx.items) { collectionView, row, source in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SourceCellId, for: IndexPath(row: row, section: 0)) as! SourceCell
                
                if let name = source.name {
                    cell.nameLabel.text = name
                }
                
                if let sourceDescription = source.sourceDescription {
                    cell.descriptionLabel.text = sourceDescription
                }
                
                return cell
            }
            .addDisposableTo(disposeBag)
    }
}

extension SourceListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 60
        let cellSize = collectionView.frame.width - padding
        
        return CGSize(width: cellSize / 2, height: cellSize / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
