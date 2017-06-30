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
    let newsAPI: NewsAPIProtocol
    
    init(realm: Realm, newsAPI: NewsAPIProtocol) {
        self.realm = realm
        self.newsAPI = newsAPI
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
    
    func fetchSources(for category: NewsAPISwift.Category) -> Observable<Results<SourceObject>> {
        let sourcesFetcher = newsAPI.getSources(category: category)
            .flatMap { Observable.from($0) }
        
        add(observable: sourcesFetcher)
        
        let sortedResults = fetchSources()
            .map { results -> Results<SourceObject> in
                return results.sorted(byKeyPath: "name", ascending: true)
            }
        
        return sortedResults
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
