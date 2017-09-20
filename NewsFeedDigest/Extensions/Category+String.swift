//
//  Category+String.swift
//  NewsFeedDigest
//
//  Created by Lucas on 20/09/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import NewsAPISwift

extension NewsAPISwift.Category: CustomStringConvertible {
    public var description: String {
        switch self {
        case .business:
            return "Business"
        case .entertainment:
            return "Entertainment"
        case .gaming:
            return "Gaming"
        case .general:
            return "General"
        case .music:
            return "Music"
        case .politics:
            return "Politics"
        case .scienceAndNature:
            return "Science and Nature"
        case .sport:
            return "Sport"
        case .technology:
            return "Technology"
        }
    }
}
