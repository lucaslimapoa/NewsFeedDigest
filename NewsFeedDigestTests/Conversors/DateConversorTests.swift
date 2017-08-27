//
//  PublishedTimeConversorTests.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/13/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import XCTest

@testable import NewsFeedDigest

class DateConversorTests: XCTestCase {
    
    var subject: MockDateConversor!
    
    override func setUp() {
        super.setUp()
        subject = MockDateConversor(currentDate: createMockDate())
    }
    
    func test_UTC0PublishedTime_ReturnsPassedTime() {
        var timeInterval: Double = 1497376800
        var expectedDiff = "30m ago"
        var actualDiff = subject.convertToPassedTime(timeInterval: timeInterval)
        
        XCTAssertEqual(expectedDiff, actualDiff)
        
        timeInterval = 1497375900
        expectedDiff = "45m ago"
        actualDiff = subject.convertToPassedTime(timeInterval: timeInterval)

        XCTAssertEqual(expectedDiff, actualDiff)
        
        timeInterval = 1497375013
        expectedDiff = "59m ago"
        actualDiff = subject.convertToPassedTime(timeInterval: timeInterval)
        
        XCTAssertEqual(expectedDiff, actualDiff)
        
        timeInterval = 1497292200
        expectedDiff = "1d ago"
        actualDiff = subject.convertToPassedTime(timeInterval: timeInterval)
        
        XCTAssertEqual(expectedDiff, actualDiff)
    }
    
    func test_WhenCurrentTimeIsOutdated_UpdateAndReturnsPassedTime() {        
        let timeInterval: Double = 1497382200
        let expectedDiff = "30m ago"
        let actualDiff = subject.convertToPassedTime(timeInterval: timeInterval)
        
        XCTAssertEqual(expectedDiff, actualDiff)
    }
    
    func test_ConvertToTimeInterval() {
        let publishedTime = "2017-06-13T19:30:00Z"
        
        let expectedResult: Double = 1497382200
        let actualResult = subject.convertToTimeInterval(publishedTime)
        
        XCTAssertEqual(expectedResult, actualResult)
    }
}

extension DateConversorTests {
    
    class MockDateConversor: DateConversor {
        override func updateCurrentTime(date: Date) {
            let currentMockDate = createMockDate(hour: 20, minute: 0)
            super.updateCurrentTime(date: currentMockDate)
        }
    }
    
}

func createMockDate(hour: Int = 18, minute: Int = 30) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year = 2017
    dateComponents.month = 6
    dateComponents.day = 13
    dateComponents.hour = hour
    dateComponents.minute = minute
    dateComponents.second = 0
    dateComponents.timeZone = TimeZone(abbreviation: "UTC")
    
    let calendar = Calendar.current
    return calendar.date(from: dateComponents)!
}
