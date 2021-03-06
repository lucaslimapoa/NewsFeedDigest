//
//  ArticleInteractor.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 7/5/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import RxRealm
import RealmSwift
import NewsAPISwift

struct ArticleInteractor {
    
    let realm: Realm
    let dateConversor: DateConversorType
    let newsAPI: NewsAPIProtocol
    
    let disposeBag = DisposeBag()
    
    init(newsAPI: NewsAPIProtocol, realm: Realm, dateConversor: DateConversorType) {
        self.newsAPI = newsAPI
        self.realm = realm
        self.dateConversor = dateConversor
    }
    
    func add(observable: Observable<NewsAPIArticle>) {
        observable
            .map { (article: NewsAPIArticle) -> ArticleObject in
                let articleObject = ArticleObject(article: article)
                
                if let publishedAt = article.publishedAt {
                    articleObject.timeInterval = self.dateConversor.convertToTimeInterval(publishedAt)
                }
                
                return articleObject
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { article in
                if self.realm.objects(ArticleObject.self)
                    .filter("title == %@ AND sourceId == %@", article.title, article.sourceId).count == 0 {
                    do {
                        try self.realm.write {
                            self.realm.add(article)
                        }
                    } catch let error {
                        fatalError("\(error.localizedDescription)")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchArticles(observable: Observable<SourceObject>, predicate: String? = nil) {
        let fetchArticlesStream = observable
            .map { self.newsAPI.getArticles(sourceId: $0.id) }
            .merge()
            .flatMapLatest { Observable.from($0) }
        
        add(observable: fetchArticlesStream)                
    }
    
    func fetchArticles(favoritesStream: Observable<[String]>) -> Observable<Results<ArticleObject>> {
        return favoritesStream
            .observeOn(MainScheduler.instance)
            .map { (sources: [String]) -> Results<ArticleObject> in
                let results = self.realm.objects(ArticleObject.self)
                let filteredResults = results.filter("sourceId IN %@", sources)
                
                return filteredResults
            }
            .flatMap { Observable.from(optional: $0) }
            .flatMap { Observable.collection(from: $0)}
    }
    
    func fetchSavedArticles() -> Observable<Results<ArticleObject>> {
        let results = realm.objects(ArticleObject.self).filter("isSaved == true")
        return Observable.collection(from: results)
    }
    
    func fetchArticles(from sourceId: SourceId) -> [ArticleObject] {
        let results = realm.objects(ArticleObject.self).filter("sourceId == '\(sourceId)'")
        return results.toArray()
    }
}
