//
//  PublishedTimeConversor.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/13/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import Foundation

protocol DateConversorType {
    func convertToDate(string: String) -> Date?
    func convertToPassedTime(publishedDate: String) -> String?
}

class DateConversor: DateConversorType {
    private var currentDate: Date
    private let dateFormatter: DateFormatter
    private let formats = [ "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HH:mm:ss.SSSZ" ]
    
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
    
    func convertToPassedTime(publishedDate: String) -> String? {
        guard let publishedInterval = convertToDate(string: publishedDate)?.timeIntervalSince1970 else { return nil }
        
        let currentInterval = currentDate.timeIntervalSince1970
        let difference = Int(currentInterval - publishedInterval)
        
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
}
