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
import NewsAPISwift

@testable import NewsFeedDigest

class NewsFeedViewModelTests: XCTestCase {
    
    var testScheduler: TestScheduler!
    var viewModel: NewsFeedViewModel!
    var disposeBag: DisposeBag!
    var subject: NewsFeedViewModel!
    
    override func setUp() {
        super.setUp()
        
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        let userStore = MockUserStore()
        let mockNewsAPIClient = MockNewsAPI(key: "")
        let mockDateConversor = DateConversor(currentDate: createMockDate())
        
        subject = NewsFeedViewModel(userStore: userStore, newsAPIClient: mockNewsAPIClient, dateConversor: mockDateConversor)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_FetchingArticles_SortByDate() {
        let tempArticles = createMockArticles()
        
        let expectedArticles = createSortedMockArticles()
        let actualArticles = subject.sortByDate(tempArticles)
        
        XCTAssertEqual(expectedArticles, actualArticles)
    }
    
    func test_FetchArticles() {
        let testExpectation = expectation(description: "Should fetch the articles sorted by date")
        
        let expectedArticles = createSortedMockArticles()
        let fetchArticlesObservable = subject.createArticlesFetcher()
        
        fetchArticlesObservable.subscribe(onNext: { articles in
            XCTAssertEqual(expectedArticles, articles)
        }, onError: { _ in
            XCTFail("Should return articles sorted by date")
        }, onCompleted: { _ in
            testExpectation.fulfill()
        }).addDisposableTo(disposeBag)
        
        testScheduler.start()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func createSortedMockArticles() -> [NewsAPIArticle] {
        let tempArticles = createMockArticles()
        return [tempArticles[2], tempArticles[1], tempArticles[0]]
    }
}
