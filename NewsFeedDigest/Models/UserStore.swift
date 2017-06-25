//
//  UserSources.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/9/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import NewsAPISwift

protocol UserStoreType {
    func fetchFollowingSources() -> Observable<NewsAPISource>
    func find(sourceId: SourceId?) -> NewsAPISource?
}

class FakeUserStore: UserStoreType {
    
    let sources = [
        NewsAPISource(id: "the-verge", name: "The Verge", sourceDescription: "", url: "", category: Category.technology, language: Language.english, country: Country.unitedStates, sortBysAvailable: [.top, .latest]),
        NewsAPISource(id: "polygon", name: "Polygon", sourceDescription: "", url: "", category: Category.gaming, language: Language.english, country: Country.unitedStates, sortBysAvailable: [.top])
    ]
    
    func fetchFollowingSources() -> Observable<NewsAPISource> {
        return Observable.from(sources)
    }
    
    func find(sourceId: SourceId?) -> NewsAPISource? {
        return sources.first { $0.id == sourceId }
    }
}
