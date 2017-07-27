//
//  NewsFeedCell.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/10/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import Nuke

class NewsFeedCell: UITableViewCell {
    
    var articleImageView: UIImageView = {
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
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    var informationText: UILabel = {
       let infoText = UILabel()
        infoText.translatesAutoresizingMaskIntoConstraints = false
        infoText.backgroundColor = .clear
        infoText.font = Fonts.cellInformationFont
        infoText.textColor = Colors.subtitleText
        
        return infoText
    }()
    
//    var separatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(r: 224, g: 224, b: 224)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        
//        return view
//    }()
    
    var viewModel: NewsCellViewModel! {
        didSet {
            contentDescription.attributedText = viewModel.articleDescription
            informationText.attributedText = viewModel.articleInfo
            
            articleImageView.image = nil
            if let urlToImage = viewModel.urlToImage {
                Nuke.loadImage(with: urlToImage, into: articleImageView)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method not implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupCell()
//        setupSeparator()
    }
    
    private func addSubviews() {
        addSubview(articleImageView)
        addSubview(contentDescription)
        addSubview(informationText)
//        addSubview(separatorView)
    }
    
//    private func setupSeparator() {
//        separatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
//        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1.0).isActive = true
//        separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 26.0).isActive = true
//        separatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//    }
    
    func setupCell() {        
        articleImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        articleImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0).isActive = true
        articleImageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        articleImageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        contentDescription.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentDescription.heightAnchor.constraint(equalToConstant: 99.0).isActive = true
        contentDescription.leftAnchor.constraint(equalTo: articleImageView.rightAnchor, constant: 8.0).isActive = true
        contentDescription.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        
        informationText.leftAnchor.constraint(equalTo: contentDescription.leftAnchor, constant: 5).isActive = true
        informationText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        informationText.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        informationText.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}
