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
    
    func getArticles(sourceId: SourceId, sortBy: SortBy? = nil) -> Observable<[NewsAPIArticle]> {
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
    
    func getSources(category: NewsAPISwift.Category?, language: Language? = nil, country: Country? = nil) -> Observable<[NewsAPISource]> {
        return Observable.create { observer in
            
            self.getSources(category: category, language: language, country: country) { result in
                switch result {
                case .success(let sources):
                    observer.onNext(sources)
                    observer.onCompleted()
                case .error(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}

extension NewsAPISwift.Category {
    func convert() -> String {
        switch self {
        case .business:
            return "Business"
        case .entertainment:
            return "Entertainment"
        case .gaming:
            return "Gaming"
        case .general:
            return "General"
        case .music:
            return "Music"
        case .politics:
            return "Politics"
        case .scienceAndNature:
            return "Science and Nature"
        case .sport:
            return "Sport"
        case .technology:
            return "Technology"
        
        }
    }
}
