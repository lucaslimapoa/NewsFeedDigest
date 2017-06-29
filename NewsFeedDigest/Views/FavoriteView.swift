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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "ic_favorite_border").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Colors.notFavoriteTint
        
        return imageView
    }()
    
    var button: UIButton = {
        var button = UIButton()
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonDidGetTouched), for: .touchUpInside)
        
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
        addSubview(imageView)
        addSubview(button)
        
        imageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
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
