//
//  FavoriteView.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/28/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

enum FavoriteViewState {
    case isFavorite
    case isNotFavorite
}

class FavoriteView: UIView {
    
    var didFavorite: (() -> Void)?
    var didUnfavorite: (() -> Void)?
    
    var viewState: FavoriteViewState = .isNotFavorite {
        didSet {
            let tintColor = (viewState == .isFavorite) ?
                Colors.favoriteTint : Colors.notFavoriteTint
            
            imageView.tintColor = tintColor
        }
    }
    
    var imageView: UIImageView = {
        var imageView = UIImageView()
        
        
        return imageView
    }()
    
}
