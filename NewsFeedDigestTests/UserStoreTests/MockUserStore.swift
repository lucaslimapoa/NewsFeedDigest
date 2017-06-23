//
//  MockUserStore.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/22/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import Foundation
import RxSwift
import NewsAPISwift

@testable import NewsFeedDigest

class MockUserStore: UserStoreProtocol {
    
    func fetchFollowingSources() -> Observable<NewsAPISource> {
        return Observable.from(mockFollowingSources)
    }
}

let mockFollowingSources = [
    NewsAPISource(id: "source-1", name: "Source 1", sourceDescription: "", url: "", category: Category.technology, language: Language.english, country: Country.unitedStates, sortBysAvailable: [.top])
]
