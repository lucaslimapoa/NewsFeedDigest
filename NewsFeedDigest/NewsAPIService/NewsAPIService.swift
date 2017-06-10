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
