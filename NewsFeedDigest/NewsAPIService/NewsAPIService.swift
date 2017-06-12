//
//  NewsAPIService.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import NewsAPISwift
import RxSwift

extension NewsAPIProtocol {
    
    func getArticles(sourceId: SourceId, sortBy: SortBy) -> Observable<[NewsAPIArticle]> {
        return Observable.create { observer in
            self.getArticles(sourceId: sourceId, sortBy: sortBy) { result in
                switch result {
                case .success(let articles):
                    observer.onNext(articles)
                    observer.onCompleted()
                    break
                case .error(let error):
                    observer.onError(error)
                    break
                }
            }
            
            return Disposables.create()
        }
    }
    
}

extension NewsAPIArticle {
    
    var attributedDescription: NSAttributedString? {
        guard let title = title, let articleDescription = articleDescription else { return nil }
        
        let attributedText = NSMutableAttributedString(string: "\(title)\n", attributes: [NSFontAttributeName: Fonts.cellTitleFont])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        
        attributedText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attributedText.string.characters.count))
        attributedText.append(NSAttributedString(string: articleDescription, attributes: [NSForegroundColorAttributeName: Colors.cellInformationText, NSFontAttributeName: Fonts.cellDescriptionFont]))
        
        return attributedText
    }
}
