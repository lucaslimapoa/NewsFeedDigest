//
//  NewsFeedCell.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/10/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

class NewsFeedCell: UICollectionViewCell {        
    
    var articleTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0)
        
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("method not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.backgroundColor = .red
        
        addSubview(articleTitle)
        
        articleTitle.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        articleTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        articleTitle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        articleTitle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
