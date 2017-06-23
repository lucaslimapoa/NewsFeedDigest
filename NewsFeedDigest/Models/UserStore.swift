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
}

class FakeUserStore: UserStoreType {
    
    let sources = [
        NewsAPISource(id: "the-verge", name: "The Verge", sourceDescription: "", url: "", category: Category.technology, language: Language.english, country: Country.unitedStates, sortBysAvailable: [.top, .latest])
    ]
    
    func fetchFollowingSources() -> Observable<NewsAPISource> {
        return Observable.from(sources)
    }
}
