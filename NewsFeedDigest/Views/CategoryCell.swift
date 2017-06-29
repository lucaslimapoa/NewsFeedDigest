//
//  CategoryCell.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/27/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.numberOfLines = 3
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAsCardView()
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("CategoryCell should be instantiated from code.")
    }
    
    private func setupSubViews() {
        
        addSubview(nameLabel)
        
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14.0).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14.0).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14.0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
