//
//  NewsFeedViewModelTests.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/22/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RealmSwift
import NewsAPISwift

@testable import NewsFeedDigest

class NewsFeedViewModelTests: XCTestCase {
    
    var viewModel: NewsFeedViewModel!
    var disposeBag: DisposeBag!
    var subject: NewsFeedViewModel!
    var realm: Realm!
    
    var articleInteractor: ArticleInteractor!
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        
        let mockNewsAPIClient = MockNewsAPI(key: "")
        let mockDateConversor = DateConversor(currentDate: createMockDate())
        realm = createInMemoryRealm(with: createMockSources())
        
        articleInteractor = ArticleInteractor(newsAPI: mockNewsAPIClient, realm: realm, dateConversor: mockDateConversor)
        
        let sourceInteractor = SourceInteractor(realm: realm, newsAPI: mockNewsAPIClient)
        sourceInteractor.add(observable: Observable.from(createMockSources()))
        sourceInteractor.setFavorite(for: "a", isFavorite: true)        
        
        subject = NewsFeedViewModel(articleInteractor: articleInteractor, sourceInteractor: sourceInteractor, dateConversor: mockDateConversor)
    }
    
    override func tearDown() {
        cleanRealm(realm)
    }
    
    func test_FetchingArticles_SortByDate() {
        let testExpectation = expectation(description: "Should return the articles sorted by date")
        let mockArticles = createRealmMockArticles()
        let expectedArticles = [ mockArticles[2], mockArticles[1], mockArticles[0] ]
        
        addMockArticlesToRealm(mockArticles)        
        subject.fetchArticles()
        
        subject.articleSections
            .asObservable()
            .subscribe(onNext: { sections in
                XCTAssertEqual(expectedArticles, sections[0].items)
                testExpectation.fulfill()
            },
            onError: { _ in
                XCTFail("Should not fail")
            })
            .dispose()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_FetchArticles() {
        let testExpectation = expectation(description: "Should fetch the articles return ArticleSections")
        let mockArticles = [
            NewsAPIArticle(sourceId: "a", author: nil, title: "Mock 4", articleDescription: "Article Mock 4 description", url: nil, urlToImage: nil, publishedAt: "2017-06-13T17:25:00Z")
        ]
        
        articleInteractor.add(observable: Observable.from(mockArticles))
        
        subject.fetchArticles()
        subject.articleSections
            .asObservable()
            .filter { $0.count > 0 } 
            .subscribe(onNext: { sections in
                XCTAssertEqual(1, sections.count)
                testExpectation.fulfill()
            }, onError: { _ in
                XCTFail("This is not supposed to fail")
            })
            .dispose()
                
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_CreateNewsCellViewModel_FromArticle() {
        let mockArticle = createMockArticles()[0]
        let articleObject = ArticleObject(article: mockArticle)
        articleObject.timeInterval = 1497367500
        
        let cellViewModel = subject.createCellViewModel(from: articleObject)
        
        let expectedDescription = "Mock 1\nArticle Mock 1 description"
        let expectedInfo = "3h ago"
        
        XCTAssertEqual(expectedInfo, cellViewModel.information(style: .normal).string)
        XCTAssertEqual(expectedDescription, cellViewModel.title(style: .normal).string)
        
        XCTAssertNil(cellViewModel.url)
        XCTAssertNil(cellViewModel.urlToImage)
    }
    
    func addMockArticlesToRealm(_ articles: [ArticleObject]) {
        try! realm.write {
            for article in articles {
                realm.add(article)
            }
        }
    }
    
    func createRealmMockArticles() -> [ArticleObject] {
        let tempArticles = createMockArticles()
        let first = ArticleObject(article: tempArticles[0])
        first.sourceId = "a"
        first.timeInterval = 1497367500
        
        let second = ArticleObject(article: tempArticles[1])
        second.sourceId = "a"
        second.timeInterval = 1497371700
        
        let third = ArticleObject(article: tempArticles[2])
        third.sourceId = "a"
        third.timeInterval = 1497374700
        
        return [first, second, third]
    }
    
    func createMockArticleSections() -> [ArticleSection] {
        let mockArticles = createMockArticles()
        
        return [
            ArticleSection(header: "Source 1", items: [ArticleObject(article: mockArticles[0])], color: .black, sourceId: "valid-id"),
            ArticleSection(header: "Source 2", items: [ArticleObject(article: mockArticles[1])], color: .black, sourceId: "valid-id"),
            ArticleSection(header: "Source 3", items: [ArticleObject(article: mockArticles[2])], color: .black, sourceId: "valid-id")
        ]
    }
}
