//
//  UserSources.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/9/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import NewsAPISwift

protocol UserStoreProtocol {
    func fetchFollowingSources() -> Observable<NewsAPISource>
}

class UserStore: UserStoreProtocol {
    func fetchFollowingSources() -> Observable<NewsAPISource> {
        return Observable.create { _ in
            
            return Disposables.create()
        }
    }
}
