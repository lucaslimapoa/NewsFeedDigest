//
//  NewsAPI+RxTests.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/21/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import NewsAPISwift

@testable import NewsFeedDigest

class NewsAPI_RxTests: XCTestCase {
    
    var subject: MockNewsAPI!
    var disposeBag: DisposeBag!
    var testScheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        
        subject = MockNewsAPI(key: "")
        disposeBag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_GetArticles_ReturnsArticles() {
        let testExpectation = expectation(description: "Should return the articles for the source id")
        
        _ = subject.getArticles(sourceId: "valid-id")
            .subscribe(onNext: { articles in
                XCTAssertEqual(articles, createMockArticles())
            }, onError: { error in
                XCTFail("Should not error in this test")
            }, onCompleted: {
                testExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        
        testScheduler.start()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_GetArticles_ReturnsError() {
        let testExpectation = expectation(description: "Should return the articles for the source id")
        
        _ = subject.getArticles(sourceId: "invalid-id")
            .subscribe( onError: { error in
                testExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        
        testScheduler.start()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

