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
        label.text = "Business"
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCellView()
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("CategoryCell should be instantiated from code.")
    }
    
    private func setupCellView() {
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = Colors.cellBorder.cgColor
    }
    
    private func setupSubViews() {
        
        addSubview(nameLabel)
        
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14.0).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14.0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
