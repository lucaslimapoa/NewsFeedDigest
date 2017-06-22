//
//  NewsAPIService.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import NewsAPISwift

extension NewsAPIProtocol {
    
    func getArticles(sourceId: SourceId, sortBy: SortBy = .top) -> Observable<[NewsAPIArticle]> {
        return Observable.create { observer in
            
            self.getArticles(sourceId: sourceId, sortBy: sortBy) { result in
                switch result {
                case .success(let articles):
                    observer.onNext(articles)
                    observer.onCompleted()
                case .error(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
}
