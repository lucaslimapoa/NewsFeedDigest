//
//  NewsFeedCell.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/10/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

class NewsFeedCell: UICollectionViewCell {        
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .green
        
        return imageView
    }()
    
    var contentDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15.0)
        textView.isEditable = false
        textView.isSelectable = false
        
        return textView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("method not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        
        addSubview(imageView)
        addSubview(contentDescription)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        contentDescription.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentDescription.leftAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        contentDescription.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
