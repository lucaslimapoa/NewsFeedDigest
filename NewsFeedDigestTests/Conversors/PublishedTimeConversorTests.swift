//
//  PublishedTimeConversorTests.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/13/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import XCTest

@testable import NewsFeedDigest

class PublishedTimeConversorTests: XCTestCase {
    
    var subject: PublishedTimeConversor!
    
    override func setUp() {
        super.setUp()
        subject = PublishedTimeConversor(currentDate: createMockDate())
    }
    
    func test_UTC0PublishedTime_ReturnsPassedTime() {
        var publishedTime = "2017-06-13T18:00:00Z"
        var expectedDiff = "30min ago"
        var actualDiff = subject.convertToPassedTime(publishedDate: publishedTime)
        
        XCTAssertEqual(expectedDiff, actualDiff)
        
        publishedTime = "2017-06-13T17:45:00Z"
        expectedDiff = "45min ago"
        actualDiff = subject.convertToPassedTime(publishedDate: publishedTime)
        
        XCTAssertEqual(expectedDiff, actualDiff)
        
        publishedTime = "2017-06-13T17:30:00.132Z"
        expectedDiff = "59min ago"
        actualDiff = subject.convertToPassedTime(publishedDate: publishedTime)
        
        XCTAssertEqual(expectedDiff, actualDiff)
        
        publishedTime = "2017-06-12T18:30:00Z"
        expectedDiff = "1d ago"
        actualDiff = subject.convertToPassedTime(publishedDate: publishedTime)
        
        XCTAssertEqual(expectedDiff, actualDiff)
    }
    
    func createMockDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2017
        dateComponents.month = 6
        dateComponents.day = 13
        dateComponents.hour = 18
        dateComponents.minute = 30
        dateComponents.second = 0
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!
    }
}
