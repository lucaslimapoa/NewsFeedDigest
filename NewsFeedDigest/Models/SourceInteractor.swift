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

struct SourceInteractor {
    
    let realm: Realm
    let disposeBag = DisposeBag()
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func fetchFavorites(predicate: String? = nil) -> Observable<Results<FavoriteSource>> {
        var results = realm.objects(FavoriteSource.self)
        
        if let predicate = predicate {
            results = results.filter(predicate)
        }
        
        return Observable.collection(from: results)
    }
    
    func isFavorite(_ sourceId: SourceId) -> Observable<Results<FavoriteSource>> {
        return fetchFavorites(predicate: "id == '\(sourceId)'")
    }
    
    func favorite(sourceId: SourceId) {
        let newFavorite = FavoriteSource(sourceId: sourceId)
        
        Observable.just(newFavorite)
            .subscribe(realm.rx.add())
            .addDisposableTo(disposeBag)
    }
    
    func unfavorite(sourceId: SourceId) {
        isFavorite(sourceId)
            .subscribe(realm.rx.delete())
            .dispose()
    }
}
