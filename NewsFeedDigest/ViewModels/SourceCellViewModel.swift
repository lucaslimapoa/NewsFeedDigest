//
//  SourceCellViewModel.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 7/3/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import Foundation
import RxSwift
import NewsAPISwift

struct SourceCellViewModel {
    
    private(set) var sourceDescription: NSAttributedString!
    private(set) var sourceInteractor: SourceInteractor!
    
    private(set) var didFavorite: (() -> Void)?
    private(set) var didUnfavorite: (() -> Void)?
    
    var viewState: Observable<FavoriteViewState>?
    
    init(source: NewsAPISource, sourceInteractor: SourceInteractor, articleInteractor: ArticleInteractor) {
        self.sourceInteractor = sourceInteractor
        sourceDescription = createSourceDescription(source: source)
        
        if let sourceId = source.id {
            viewState = sourceInteractor.isFavorite(sourceId)
                .map { ($0.isEmpty) ?
                    FavoriteViewState.isNotFavorite : FavoriteViewState.isFavorite
            }
            
            didFavorite = {
                sourceInteractor.setFavorite(for: sourceId, isFavorite: true)
            }
            
            didUnfavorite = {
                sourceInteractor.setFavorite(for: sourceId, isFavorite: false)
                articleInteractor.deleteArticles(from: sourceId)
            }
        }
    }
    
    private func createSourceDescription(source: NewsAPISource) -> NSAttributedString {
        guard let name = source.name, let description = source.sourceDescription else {
            return NSAttributedString()
        }
        
        let attributedText = NSMutableAttributedString(string: "\(name)\n", attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16.0),
            NSForegroundColorAttributeName: UIColor(r: 0, g: 92, b: 208)
            ])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.0
        
        let range = NSMakeRange(0, attributedText.string.characters.count)
        
        attributedText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: range)
        
        attributedText.append(NSAttributedString(string: description, attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 13.0),
            NSForegroundColorAttributeName: UIColor(r: 78, g: 85, b: 94)
            ]))
        
        return attributedText
    }
}
