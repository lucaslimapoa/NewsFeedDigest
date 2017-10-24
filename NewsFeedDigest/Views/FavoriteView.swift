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

            button.imageView?.tintColor = tintColor
        }
    }
    
    var button: UIButton = {
        var button = UIButton()
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonDidGetTouched), for: .touchUpInside)
        button.setImage( #imageLiteral(resourceName: "ic_favorite_border").withRenderingMode(.alwaysTemplate), for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This view should not be instantiated through Storyboards")
    }
    
    func setupView() {
        addSubview(button)
        
        button.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func buttonDidGetTouched() {
        if viewState == .isFavorite {
            didUnfavorite?()
            viewState = .isNotFavorite
        } else {
            didFavorite?()
            viewState = .isFavorite
        }
    }
}
