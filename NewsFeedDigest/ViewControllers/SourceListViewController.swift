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

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.backgroundColor = Colors.collectionViewBackgroundColor
     
//        UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        collectionView!.contentInset = UIEdgeInsetsMake(10, 20, 10, 20)
        self.collectionView!.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCellId)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCellId, for: indexPath) as! CategoryCell
    
        cell.backgroundColor = Colors.color(for: .business)
    
        return cell
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
