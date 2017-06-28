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
    
//    var imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        return imageView
//    }()
    
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
//        addSubview(imageView)
        
        contentText.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0).isActive = true
        contentText.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        contentText.rightAnchor.constraint(equalTo: rightAnchor, constant: -8.0).isActive = true
        contentText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26.0).isActive = true
        
//        imageView.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
//        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
//        imageView.image = #imageLiteral(resourceName: "heart-icon")
    }
}
