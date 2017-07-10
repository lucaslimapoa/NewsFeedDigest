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
import Realm
import NewsAPISwift

@testable import NewsFeedDigest

class ArticleInteractorTests: XCTestCase {
    
    var mockRealm: Realm!
    var mockDateConversor: DateConversor!
    
    var subject: ArticleInteractor!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
    
        disposeBag = DisposeBag()
        
        mockDateConversor = DateConversor(currentDate: createMockDate())
        mockRealm = createInMemoryRealm()
        
        let mockNewsAPI = MockNewsAPI(key: "")
        subject = ArticleInteractor(newsAPI: mockNewsAPI, realm: mockRealm, dateConversor: mockDateConversor)
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
    
    func test_FetchSavedArticles() {
        let testExpectation = expectation(description: "Should return only saved articles")
        
        addArticlesToSubject(articles: createMockArticles())
        setIsSavedInArticles()
        
        let expectedCount = 2
        
        subject.fetchSavedArticles()
            .subscribe(onNext: { results in
                XCTAssertEqual(expectedCount, results.count)
                testExpectation.fulfill()
            }, onError: { _ in
                XCTFail("Should not error")
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_FetchArticles() {
        let testExpectation = expectation(description: "Should fetch articles from the service and save on Realm")
        
        let sourcesObservable = Observable.from(createMockSources())
            .map { SourceObject(source: $0) }
        
        subject.fetchArticles(observable: sourcesObservable)
            .subscribe(onNext: { results in
                XCTAssertEqual(3, results.count)
                testExpectation.fulfill()
            }, onError: { _ in
                XCTFail("Should not fail")
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func addArticlesToSubject(articles: [NewsAPIArticle]) {
        let articlesObservable = Observable.from(articles)
        subject.add(observable: articlesObservable)
    }
    
    func setIsSavedInArticles() {
        let allObjects = mockRealm.objects(ArticleObject.self)
        
        try! mockRealm.write {
            allObjects[0].isSaved = true
            allObjects[1].isSaved = true
        }
    }
}
