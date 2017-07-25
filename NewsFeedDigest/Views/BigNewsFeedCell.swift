//
//  BigNewsFeedCell.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 7/23/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

class BigNewsFeedCell: NewsFeedCell {
    
    override func setupCell() {
        articleImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0).isActive = true
        articleImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0).isActive = true
        articleImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0).isActive = true
        articleImageView.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
        
        contentDescription.topAnchor.constraint(equalTo: articleImageView.bottomAnchor).isActive = true
//        contentDescription.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        contentDescription.bottomAnchor.constraint(equalTo: informationText.topAnchor, constant: 8.0).isActive = true
        contentDescription.leftAnchor.constraint(equalTo: articleImageView.leftAnchor).isActive = true
        contentDescription.rightAnchor.constraint(equalTo: articleImageView.rightAnchor).isActive = true
        
//        informationText.topAnchor.constraint(equalTo: contentDescription.bottomAnchor, constant: 8.0).isActive = true
        informationText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0).isActive = true
        informationText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0).isActive = true
        informationText.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
}
