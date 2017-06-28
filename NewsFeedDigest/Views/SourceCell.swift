//
//  SourceCell.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/27/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

class SourceCell: UICollectionViewCell {
    
    var nameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13.0)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAsCardView()
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This Cell should not be initialized from Storyboard")
    }
    
    private func setupSubViews() {
        
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(imageView)
        
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        descriptionLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14).isActive = true
        
        imageView.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 12.0).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        imageView.image = #imageLiteral(resourceName: "heart-icon")
    }
}
