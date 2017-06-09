//
//  NewsFeedViewModelTests.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import XCTest

@testable import NewsFeedDigest

class NewsFeedViewModelTests: XCTestCase {
    
    var viewModel: MockNewsFeedViewModel!
    
    override func setUp() {
        super.setUp()
        
        viewModel = MockNewsFeedViewModel()
    }
    
    
    
}

extension NewsFeedViewModelTests {
    
    class MockNewsFeedViewModel: NewsFeedViewModel {
        
    }
}
