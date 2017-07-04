//
//  NewsCellViewModel.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 7/3/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import NewsAPISwift

struct NewsCellViewModel {
    
    private(set) var articleDescription: NSAttributedString!
    private(set) var articleInfo: NSAttributedString!
    private(set) var urlToImage: URL?
    private(set) var url: URL?
    
    init(_ tuple: (article: NewsAPIArticle, source: NewsAPISource?), dateConversor: DateConversorType) {
        var date: String?
        
        if let publishedAt = tuple.article.publishedAt {
            date = dateConversor.convertToPassedTime(publishedAt: publishedAt)
        }
        
        articleInfo = createInformation(source: tuple.source, publishedAt: date)
        articleDescription = createDescription(title: tuple.article.title, description: tuple.article.articleDescription)
        
        urlToImage = tuple.article.urlToImage
        url = tuple.article.url
    }
    
    func createDescription(title: String?, description: String?) -> NSAttributedString {
        guard let title = title, let articleDescription = description else { return NSAttributedString() }
        
        let attributedText = NSMutableAttributedString(string: "\(title)\n", attributes: [NSFontAttributeName: Fonts.cellTitleFont])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.0
        
        attributedText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attributedText.string.characters.count))
        attributedText.append(NSAttributedString(string: articleDescription, attributes: [NSForegroundColorAttributeName: Colors.cellInformationText, NSFontAttributeName: Fonts.cellDescriptionFont]))
        
        return attributedText
    }
    
    func createInformation(source: NewsAPISource?, publishedAt: String?) -> NSAttributedString {
        let sourceName = source?.name ?? ""
        
        let categoryColor = Colors.color(for: source?.category)
        
        let infoText = NSMutableAttributedString(string: sourceName, attributes: [
            NSForegroundColorAttributeName: categoryColor,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)
            ])
        
        if let publishedAt = publishedAt {
            infoText.append(NSAttributedString(string: " | \(publishedAt)", attributes: [
                NSForegroundColorAttributeName: UIColor(red: 128/255, green: 130/255, blue: 137/255, alpha: 1.0),
                NSFontAttributeName: UIFont.systemFont(ofSize: 11.0)
                ]))
        }
        
        return infoText
    }
}
