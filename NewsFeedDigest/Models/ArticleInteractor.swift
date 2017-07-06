//
//  ArticleInteractor.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 7/5/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import RealmSwift
import NewsAPISwift

struct ArticleInteractor {
    
    let realm: Realm
    let dateConversor: DateConversorType
    
    let disposeBag = DisposeBag()
    
    init(realm: Realm, dateConversor: DateConversorType) {
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
            .subscribe(onNext: { article in
                if self.realm.objects(ArticleObject.self)
                    .filter("title == '\(article.title)' AND sourceId == '\(article.sourceId)'").count == 0 {
                    do {
                        try self.realm.write {
                            self.realm.add(article)
                        }
                    } catch let error {
                        fatalError("\(error.localizedDescription)")
                    }
                }
            })
            .dispose()
    }
    
}
