//
//  UICollectionViewCell+CardView.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/27/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    func setupAsCardView() {
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = Colors.cellBorder.cgColor
    }
    
}
