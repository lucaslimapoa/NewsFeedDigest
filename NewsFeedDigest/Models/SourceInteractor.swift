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
    
    func add(observable: Observable<NewsAPISource>) {
        observable
            .map { SourceObject(source: $0) }
            .subscribe(realm.rx.add(update: true))
            .addDisposableTo(disposeBag)
    }
    
    func fetchSources(predicate: String? = nil) -> Observable<Results<SourceObject>> {
        var results = realm.objects(SourceObject.self)
        
        if let predicate = predicate {
            results = results.filter(predicate)
        }
        
        return Observable.collection(from: results)
    }
    
    func fetchFavorites(predicate: String? = nil) -> Observable<Results<FavoriteSource>> {
        var results = realm.objects(FavoriteSource.self)
        
        if let predicate = predicate {
            results = results.filter(predicate)
        }
        
        return Observable.collection(from: results)
    }
    
    func isFavorite(_ sourceId: SourceId) -> Observable<Results<SourceObject>> {
        return fetchSources(predicate: "id == '\(sourceId)' AND isFavorite = true")
    }
    
    func setFavorite(for sourceId: SourceId, isFavorite: Bool) {
        fetchSources(predicate: "id == '\(sourceId)'")
            .map { $0.first }
            .subscribe(onNext: { sourceObject in
                try? self.realm.write {
                    sourceObject?.isFavorite = isFavorite
                }
            })
            .dispose()
    }
}
