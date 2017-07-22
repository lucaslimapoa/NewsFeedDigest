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
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        
        let userStore = MockUserStore()
        let mockNewsAPIClient = MockNewsAPI(key: "")
        let mockDateConversor = DateConversor(currentDate: createMockDate())
        realm = createInMemoryRealm(with: createMockSources())
        
        let articleInteractor = ArticleInteractor(newsAPI: mockNewsAPIClient, realm: realm, dateConversor: mockDateConversor)
        
        let sourceInteractor = SourceInteractor(realm: realm, newsAPI: mockNewsAPIClient)
        sourceInteractor.setFavorite(for: "a", isFavorite: true)        
        
        subject = NewsFeedViewModel(userStore: userStore, articleInteractor: articleInteractor, sourceInteractor: sourceInteractor, dateConversor: mockDateConversor)
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
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_FetchArticles() {
        let testExpectation = expectation(description: "Should fetch the articles return ArticleSections")
        
        subject.fetchArticles()
            
        subject.articleSections
            .asObservable()
            .subscribe(onNext: { sections in
                XCTAssertEqual(1, sections.count)
                testExpectation.fulfill()
            }, onError: { _ in
                XCTFail("This is not supposed to fail")
            })
            .disposed(by: disposeBag)
                
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_CreateNewsCellViewModel_FromArticle() {
        let mockArticle = createMockArticles()[0]
        let articleObject = ArticleObject(article: mockArticle)
        articleObject.timeInterval = 1497367500
        
        let cellViewModel = subject.createCellViewModel(from: articleObject)
        
        let expectedDescription = "Mock 1\nArticle Mock 1 description"
        let expectedInfo = "Source 1 | 3h ago"
        
        XCTAssertEqual(expectedInfo, cellViewModel.articleInfo.string)
        XCTAssertEqual(expectedDescription, cellViewModel.articleDescription.string)
        
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
            ArticleSection(header: "Source 1", items: [ArticleObject(article: mockArticles[0])]),
            ArticleSection(header: "Source 2", items: [ArticleObject(article: mockArticles[1])]),
            ArticleSection(header: "Source 3", items: [ArticleObject(article: mockArticles[2])])
        ]
    }
}
