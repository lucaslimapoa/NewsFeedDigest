//
//  NewsCellViewModel.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 7/3/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import NewsAPISwift

enum CellStyle {
    case normal, big
}

fileprivate struct CellFonts {
    
    fileprivate var titleFont: UIFont!
    fileprivate var descriptionFont: UIFont!
    fileprivate var infoFont: UIFont!
    
    init(style: CellStyle) {
        switch style {
        case .normal:
            titleFont = Fonts.cellTitleFont
            descriptionFont = Fonts.cellDescriptionFont
            infoFont = Fonts.cellInformationFont
        case .big:
            titleFont = Fonts.cellBigTitleFont
            descriptionFont = Fonts.cellBigDescriptionFont
            infoFont = Fonts.cellBigInformationFont
        }
    }
}

struct NewsCellViewModel {
    
    private var articleTitle: String?
    private var articleDescription: String?
    private var articleDate: String?
    
    private(set) var urlToImage: URL?
    private(set) var url: URL?
    
    init(_ tuple: (article: ArticleObject, source: SourceObject?), dateConversor: DateConversorType) {
        articleTitle = tuple.article.title
        articleDescription = tuple.article.articleDescription
        articleDate = dateConversor.convertToPassedTime(timeInterval: tuple.article.timeInterval)
        
        urlToImage = URL(string: tuple.article.urlToImage)
        url = URL(string: tuple.article.url)
    }
    
    func title(style: CellStyle) -> NSAttributedString {
        let cellFonts = CellFonts(style: style)
        return createDescription(title: articleTitle, description: articleDescription, cellFonts: cellFonts)
    }
    
    func information(style: CellStyle) -> NSAttributedString {
        let cellFonts = CellFonts(style: style)
        return createInformation(publishedAt: articleDate, cellFonts: cellFonts)
    }
}

private extension NewsCellViewModel {
    
    func createDescription(title: String?, description: String?, cellFonts: CellFonts) -> NSAttributedString {
        guard let title = title, let articleDescription = description else { return NSAttributedString() }
        
        let attributedText = NSMutableAttributedString(string: "\(title)\n", attributes: [NSFontAttributeName: cellFonts.titleFont])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.0
        
        attributedText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attributedText.string.count))
        attributedText.append(NSAttributedString(string: articleDescription, attributes: [NSForegroundColorAttributeName: Colors.cellInformationText, NSFontAttributeName: cellFonts.descriptionFont]))
        
        return attributedText
    }
    
    func createInformation(publishedAt: String?, cellFonts: CellFonts) -> NSAttributedString {
        let infoText = NSMutableAttributedString()
        
        if let publishedAt = publishedAt {
            infoText.append(NSAttributedString(string: publishedAt, attributes: [
                NSForegroundColorAttributeName: UIColor(red: 128/255, green: 130/255, blue: 137/255, alpha: 1.0),
                NSFontAttributeName: cellFonts.infoFont
                ]))
        }
        
        return infoText
    }
}
