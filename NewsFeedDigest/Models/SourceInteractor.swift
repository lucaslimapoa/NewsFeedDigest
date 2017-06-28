//
//  SourceInteractor.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/28/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import RxRealm
import RealmSwift
import NewsAPISwift

protocol SourceInteractorType {
    
}

struct SourceInteractor: SourceInteractorType {
    
    let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func fetchAllFavorites() -> Observable<Results<FavoriteSource>> {
        let results = realm.objects(FavoriteSource.self)
        return Observable.collection(from: results)
    }
    
}
