//
//  PublishedTimeConversor.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/13/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import Foundation
import os.log

protocol DateConversorType {
    func convertToDate(string: String) -> Date?
    func convertToPassedTime(timeInterval: Double) -> String?
    func convertToTimeInterval(_ publishedAt: String) -> TimeInterval
}

class DateConversor: DateConversorType {
    private var currentDate: Date
    private let dateFormatter: DateFormatter
    private let formats = [ "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HH:mm:ss.SSSZ" ]
    
    private let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "DateFormatter")
    
    var currentInterval: Double {
        return currentDate.timeIntervalSince1970
    }
    
    init(currentDate: Date = Date()) {
        self.currentDate = currentDate
        
        dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
    }        
    
    func convertToDate(string: String) -> Date? {
        for format in formats {
            dateFormatter.dateFormat = format
            
            if let date = dateFormatter.date(from: string) {
                return date
            }
        }
        
        return nil
    }
    
    func convertToPassedTime(timeInterval: Double) -> String? {
        if timeInterval > currentInterval {
            updateCurrentTime(date: Date())
        }
        
        let difference = Int(currentInterval - timeInterval)
        
        let minutes = (difference / 60) % 60
        let hours = difference / 3600
        
        var timePassed: String?
        
        if hours > 0 && hours < 24 {
            timePassed = "\(hours)h ago"
        } else if hours >= 24 {
            let days = hours / 24
            timePassed = "\(days)d ago"
        } else if minutes > 0 {
            timePassed = "\(minutes)m ago"
        }
        
        return timePassed
    }
    
    func convertToTimeInterval(_ publishedAt: String) -> TimeInterval {
        guard let date = convertToDate(string: publishedAt) else { return 0 }
        return date.timeIntervalSince1970
    }
    
    func updateCurrentTime(date: Date) {
        self.currentDate = date
    }
}
