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

extension NewsAPISource {
    
    var categoryColor: UIColor {
        guard let category = self.category else { return UIColor.black }        
        var color: UIColor!
        
        switch category {
        case .business:
            color = UIColor(r: 44, g: 62, b: 80)
        case .entertainment:
            color = UIColor(r: 46, g: 204, b: 113)
        case .gaming:
            color = UIColor(r: 52, g: 152, b: 219)
        case .general:
            color = UIColor(r: 231, g: 76, b: 60)
        case .music:
            color = UIColor(r: 220, g: 48, b: 35)
        case .politics:
            color = UIColor(r: 127, g: 140, b: 141)
        case .scienceAndNature:
            color = UIColor(r: 255, g: 166, b: 49)
        case .sport:
            color = UIColor(r: 211, g: 84, b: 0)
        case .technology:
            color = UIColor(r: 155, g: 89, b: 182)
        }
        
        return color
    }
}


