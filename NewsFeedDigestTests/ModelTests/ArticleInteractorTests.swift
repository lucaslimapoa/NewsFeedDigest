//
//  ArticleInteractorTests.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 7/5/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import XCTest
import RxSwift
import RealmSwift
import NewsAPISwift

@testable import NewsFeedDigest

class ArticleInteractorTests: XCTestCase {
    
    var mockRealm: Realm!
    var mockDateConversor: DateConversor!
    
    var subject: ArticleInteractor!
    
    override func setUp() {
        super.setUp()
    
        mockDateConversor = DateConversor(currentDate: createMockDate())
        mockRealm = createInMemoryRealm()
        
        subject = ArticleInteractor(realm: mockRealm, dateConversor: mockDateConversor)
    }
    
    func test_AddArticles() {
        addArticlesToSubject(articles: createMockArticles())
        XCTAssertEqual(mockRealm.objects(ArticleObject.self).count, 3)
    }
    
    func test_DontDuplicateArticles() {
        addArticlesToSubject(articles: createMockArticles())
        addArticlesToSubject(articles: createMockArticles())
        
        XCTAssertEqual(mockRealm.objects(ArticleObject.self).count, 3)
    }
    
    func addArticlesToSubject(articles: [NewsAPIArticle]) {
        let articlesObservable = Observable.from(articles)
        subject.add(observable: articlesObservable)
    }
}
