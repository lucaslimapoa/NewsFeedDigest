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
    
    func getArticles(from sources: [NewsAPISource], sortBy: SortBy? = nil) -> Observable<[NewsAPIArticle]> {
        return Observable.create { observer in
            let semaphore = DispatchSemaphore(value: 1)
            var count = sources.count
            
            for source in sources {
                guard let sourceId = source.id else { continue }
                
                self.getArticles(sourceId: sourceId, sortBy: sortBy) { result in
                    switch result {
                    case .success(let articles):
                        observer.onNext(articles)
                        break
                    default:
                        break
                    }
                    
                    count -= 1
                    
                    if count <= 0 {
                        semaphore.signal()
                    }
                }
            }
            
            semaphore.wait()
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
}
