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
            .subscribe(onNext: { source in
                let properties = [
                    "id": source.id ?? "",
                    "name": source.name ?? "",
                    "sourceDescription": source.sourceDescription ?? "",
                    "category": source.category?.rawValue ?? "",
                    "language": source.language?.rawValue ?? "",
                    "country": source.country?.rawValue ?? ""
                ]
                
                do {
                    try self.realm.write {
                        self.realm.create(SourceObject.self, value: properties, update: true)
                    }
                } catch let error {
                    fatalError("\(error.localizedDescription)")
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func fetchSources(predicate: String? = nil) -> Observable<Results<SourceObject>> {
        var results = realm.objects(SourceObject.self)
        
        if let predicate = predicate {
            results = results.filter(predicate)
        }
        
        return Observable.collection(from: results)
    }
    
    func fetchFavoritesById() -> [SourceId] {
        let results = realm.objects(SourceObject.self).filter("isFavorite == %@", true)
        return results.toArray().map { $0.id }
    }
    
    func fetchSources(for category: NewsAPISwift.Category) -> Observable<Results<SourceObject>> {
        let sourcesFetcher = newsAPI.getSources(category: category)
            .flatMap { Observable.from($0) }
            .observeOn(MainScheduler.instance)
        
        add(observable: sourcesFetcher)
        
        let sortedResults = fetchSources(predicate: "category == '\(category.rawValue)'")
            .map { results -> Results<SourceObject> in
                return results.sorted(byKeyPath: "name", ascending: true)
            }
            .asObservable()
        
        return sortedResults
    }
    
    func fetchSource(with id: SourceId) -> SourceObject? {
        return realm.objects(SourceObject.self).filter("id == %@", id).first
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
