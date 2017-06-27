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
        
        subject = SourceListViewModel()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
}
