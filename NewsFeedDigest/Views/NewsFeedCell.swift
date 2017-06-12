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
    
    var informationText: UILabel = {
       let infoText = UILabel()
        infoText.translatesAutoresizingMaskIntoConstraints = false
        infoText.backgroundColor = .white
        infoText.font = UIFont.systemFont(ofSize: 11.0)
        infoText.textColor = Colors.subtitleText
        infoText.text = "The Verge / 30 min"
        
        return infoText
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("method not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        
        addSubview(imageView)
        addSubview(contentDescription)
        addSubview(informationText)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        contentDescription.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentDescription.bottomAnchor.constraint(equalTo: informationText.topAnchor).isActive = true
        contentDescription.leftAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        contentDescription.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        informationText.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        informationText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        informationText.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        informationText.heightAnchor.constraint(equalToConstant: 15)
    }
}
