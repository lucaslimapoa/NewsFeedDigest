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

class ListViewModelTests: XCTestCase {
    
    var subject: ListViewModel!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()

        let mockNewsAPI = MockNewsAPI(key: "")
        let mockRealm = createInMemoryRealm()
        
        let sourceInteractor = SourceInteractor(realm: mockRealm, newsAPI: mockNewsAPI)
        
        subject = ListViewModel(sourceInteractor: sourceInteractor)
        subject.sourceInteractor = sourceInteractor
        
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
                testExpectation.fulfill()
            }, onError: { _ in
                XCTFail("Should not error")
            })
            .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func createSortedMockSources() -> [NewsAPISource] {
        let unsortedSources = createMockSources()
        return [
            unsortedSources[0],
            unsortedSources[4],
            unsortedSources[3]
        ]
    }
}
