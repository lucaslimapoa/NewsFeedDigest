//
//  NewsFeedViewControllerTests.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/23/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import XCTest
import NewsAPISwift
import RxTest

@testable import NewsFeedDigest

class NewsFeedViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func createNewsFeedViewModel() -> NewsFeedViewModel {
        let userStore = MockUserStore()
        let newsAPI = MockNewsAPI(key: "")
        
        return NewsFeedViewModel(userStore: userStore, newsAPIClient: newsAPI)
    }
}
