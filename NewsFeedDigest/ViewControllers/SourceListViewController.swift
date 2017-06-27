//
//  SourceListViewController.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

private let CategoryCellId = "CategoryCellId"

class SourceListViewController: UICollectionViewController {

    var viewModel: SourceListViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.backgroundColor = Colors.collectionViewBackgroundColor
     
        collectionView!.dataSource = nil
        collectionView!.contentInset = UIEdgeInsetsMake(10, 20, 10, 20)
        self.collectionView!.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCellId)
        
        setupRx()
    }

    func setupRx() {
        
        
        
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
