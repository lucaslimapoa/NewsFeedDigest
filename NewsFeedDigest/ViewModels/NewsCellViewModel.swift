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
    
    init(_ tuple: (article: ArticleObject, source: SourceObject?), dateConversor: DateConversorType) {
        let date: String? = dateConversor.convertToPassedTime(timeInterval: tuple.article.timeInterval)
        
        articleInfo = createInformation(source: tuple.source, publishedAt: date)
        articleDescription = createDescription(title: tuple.article.title, description: tuple.article.articleDescription)
        
        urlToImage = URL(string: tuple.article.urlToImage)
        url = URL(string: tuple.article.url)
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
    
    func createInformation(source: SourceObject?, publishedAt: String?) -> NSAttributedString {
        let infoText = NSMutableAttributedString()
        
        if let publishedAt = publishedAt {
            infoText.append(NSAttributedString(string: publishedAt, attributes: [
                NSForegroundColorAttributeName: UIColor(red: 128/255, green: 130/255, blue: 137/255, alpha: 1.0),
                NSFontAttributeName: Fonts.cellPublishedAtFont
                ]))
        }
        
        return infoText
    }
}
