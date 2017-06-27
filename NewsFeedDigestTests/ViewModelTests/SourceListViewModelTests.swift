//
//  SourceListViewModelTests.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/26/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import XCTest
import NewsAPISwift
import RxSwift
import RxTest

@testable import NewsFeedDigest

class SourceListViewModelTests: XCTestCase {
    
    var subject: SourceListViewModel!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        
        subject = SourceListViewModel(newsAPI: MockNewsAPI(key: ""))
        disposeBag = DisposeBag()
    }
    
    func test_FetchAvailableCategories() {
        let testExpectation = expectation(description: "Should return all available categories")
        let expectedResult: [NewsAPISwift.Category] = [.business, .entertainment, .gaming, .general, .music, .politics, .scienceAndNature, .sport, .technology]
        
        subject.fetchAvailableCategories()
            .subscribe(onNext: { categories in
                XCTAssertEqual(expectedResult, categories)
            }, onError: { _ in
                XCTFail("Should not return error")
            }, onCompleted: {
                testExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
                
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_FetchSourcesForCategory() {
        let testExpectation = expectation(description: "Should return articles for a given category")
        let expectedResult = createSortedMockSources()
        
        subject.fetchSources(for: Category.business)
            .subscribe(onNext: { sources in
                XCTAssertEqual(expectedResult, sources)
            }, onError: { _ in
                XCTFail("Should not error")
            }, onCompleted: {
                testExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_SortSourcesAlphabetically() {
        let expectedResult = createSortedMockSources()
        let actualResult = subject.sortAlphabetically(sources: createMockSources())
        
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func createSortedMockSources() -> [NewsAPISource] {
        let unsortedSources = createMockSources()
        return [
            unsortedSources[0],
            unsortedSources[2],
            unsortedSources[1],
            unsortedSources[4],
            unsortedSources[3]
        ]
    }
}
