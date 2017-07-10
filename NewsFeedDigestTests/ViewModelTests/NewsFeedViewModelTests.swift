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
    
    var viewModel: NewsFeedViewModel!
    var disposeBag: DisposeBag!
    var subject: NewsFeedViewModel!
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        
        let userStore = MockUserStore()
        let mockNewsAPIClient = MockNewsAPI(key: "")
        let mockDateConversor = DateConversor(currentDate: createMockDate())
        
        subject = NewsFeedViewModel(userStore: userStore, newsAPIClient: mockNewsAPIClient, dateConversor: mockDateConversor)
    }
    
    func test_FetchingArticles_SortByDate() {
        let tempArticles = createMockArticles()
        
        let expectedArticles = createSortedMockArticles()
        let actualArticles = subject.sortByDate(tempArticles)
        
        XCTAssertEqual(expectedArticles, actualArticles)
    }
    
    func test_FetchArticles() {
        let testExpectation = expectation(description: "Should fetch the articles sorted by date")        
        
        subject.fetchArticles()
            .subscribe(onNext: { sections in
                XCTAssertEqual(3, sections.count)
                testExpectation.fulfill()
            }, onError: { _ in
                XCTFail("This is not supposed to fail")
            })
            .disposed(by: disposeBag)
        
                
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_CreateNewsCellViewModel_FromArticle() {
        let article = createMockArticles()[0]
        let cellViewModel = subject.createCellViewModel(from: article)
        
        let expectedDescription = "Mock 1\nArticle Mock 1 description"
        let expectedInfo = "Source 1 | 3h ago"
        
        XCTAssertEqual(expectedInfo, cellViewModel.articleInfo.string)
        XCTAssertEqual(expectedDescription, cellViewModel.articleDescription.string)
        
        XCTAssertNil(cellViewModel.url)
        XCTAssertNil(cellViewModel.urlToImage)
    }
    
    func createSortedMockArticles() -> [NewsAPIArticle] {
        let tempArticles = createMockArticles()
        return [tempArticles[2], tempArticles[1], tempArticles[0]]
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
