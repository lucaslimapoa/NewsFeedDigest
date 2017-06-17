//
//  UserSources.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/9/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import NewsAPISwift

fileprivate let sources = [
            NewsAPISource(id: "the-verge", name: "The Verge", sourceDescription: "", url: "", category: Category.technology, language: Language.english, country: Country.unitedStates, sortBysAvailable: [SortBy.latest]),
            NewsAPISource(id: "polygon", name: "Polygon", sourceDescription: "", url: "", category: Category.gaming, language: Language.english, country: Country.unitedStates, sortBysAvailable: [SortBy.latest]),
            NewsAPISource(id: "techcrunch", name: "Techcrunch", sourceDescription: "", url: "", category: Category.technology, language: Language.english, country: Country.unitedStates, sortBysAvailable: [SortBy.latest]),
            NewsAPISource(id: "mashable", name: "Mashable", sourceDescription: "", url: "", category: Category.entertainment, language: Language.english, country: Country.unitedStates, sortBysAvailable: [SortBy.latest])
        ]

protocol UserModelProtocol {
    func getSources() -> Observable<NewsAPISource>
    func getSource(by sourceId: SourceId) -> NewsAPISource?
}

class UserModel: UserModelProtocol {
    
    func getSources() -> Observable<NewsAPISource> {
        return Observable.create { observer in
            
            for source in sources {
                observer.onNext(source)
            }
            
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getSource(by sourceId: SourceId) -> NewsAPISource? {
        return sources.first { $0.id == sourceId }
    }
    
}
