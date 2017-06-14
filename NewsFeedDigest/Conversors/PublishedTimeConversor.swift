//
//  PublishedTimeConversor.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/13/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import Foundation

class PublishedTimeConversor {
    let dateFormatter: DateFormatter
    var currentDate: Date
    
    init(currentDate: Date = Date()) {
        self.currentDate = currentDate
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone.current
    }        
    
    func convertToPassedTime(publishedDate: String) -> String? {
        guard let publishedInterval = dateFormatter.date(from: publishedDate)?.timeIntervalSince1970 else { return nil }
        
        let currentInterval = currentDate.timeIntervalSince1970
        let difference = Int(currentInterval - publishedInterval)
        
        let minutes = (difference / 60) % 60
        let hours = difference / 3600
        
        if hours > 0 {
            return "\(hours)h ago"
        } else if minutes > 0 {
            return "\(minutes)min ago"
        }
        
        return nil
    }
}
