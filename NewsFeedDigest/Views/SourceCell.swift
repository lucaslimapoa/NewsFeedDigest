//
//  SourceCell.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/27/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

class SourceCell: UICollectionViewCell {
    
    var contentText: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    let favoriteView = FavoriteView()
    
    var viewModel: SourceCellViewModel! {
        didSet {
            contentText.attributedText = viewModel?.sourceDescription
            
            favoriteView.didFavorite = { [weak self] in
                self?.viewModel.didFavorite?()
            }
            
            favoriteView.didUnfavorite = { [weak self] in
                self?.viewModel.didUnfavorite?()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAsCardView()
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This Cell should not be initialized from Storyboard")
    }
    
    private func setupSubViews() {
        
        addSubview(contentText)
        addSubview(favoriteView)
        
        contentText.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0).isActive = true
        contentText.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        contentText.rightAnchor.constraint(equalTo: rightAnchor, constant: -8.0).isActive = true
        contentText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26.0).isActive = true
                
        favoriteView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        favoriteView.rightAnchor.constraint(equalTo: rightAnchor, constant: -6).isActive = true
    }
}
