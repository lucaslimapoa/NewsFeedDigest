//
//  NewsFeedCell.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/10/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import Nuke

class NewsFeedCell: UICollectionViewCell {        
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        
        return imageView
    }()
    
    var contentDescription: UITextView = {
        let textView = UITextView()
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.translatesAutoresizingMaskIntoConstraints = false        
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    var informationText: UILabel = {
       let infoText = UILabel()
        infoText.translatesAutoresizingMaskIntoConstraints = false
        infoText.backgroundColor = .white
        infoText.font = Fonts.cellInformationFont
        infoText.textColor = Colors.subtitleText
        infoText.text = "The Verge / 30 min"
        
        return infoText
    }()
    
    var viewModel: NewsCellViewModel! {
        didSet {
            contentDescription.attributedText = viewModel.articleDescription
            informationText.attributedText = viewModel.articleInfo
            
            imageView.image = nil
            if let urlToImage = viewModel.urlToImage {
                Nuke.loadImage(with: urlToImage, into: imageView)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("method not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCellView()
        setupSubViews()
    }
    
    private func setupCellView() {
        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = Colors.cellBorder.cgColor
        
        self.backgroundColor = .white
        self.clipsToBounds = true
    }
    
    private func setupSubViews() {
        addSubview(imageView)
        addSubview(contentDescription)
        addSubview(informationText)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 84.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 84.0).isActive = true
        
        contentDescription.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentDescription.heightAnchor.constraint(equalToConstant: 85).isActive = true
        contentDescription.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8.0).isActive = true
        contentDescription.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        
        informationText.leftAnchor.constraint(equalTo: contentDescription.leftAnchor, constant: 5).isActive = true
        informationText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        informationText.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        informationText.heightAnchor.constraint(equalToConstant: 15)
    }
}
