//
//  Constants.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

struct Colors {    
    static let collectionViewBackgroundColor = UIColor.white
    static let subtitleText = UIColor(red: 138/255, green: 140/255, blue: 147/255, alpha: 1.0)
    static let cellInformationText = UIColor(red: 128/255, green: 130/255, blue: 137/255, alpha: 1.0)
    static let cellBorder = UIColor(red: 203/255, green: 207/255, blue: 213/255, alpha: 1.0)
    
    static func color(for category: NewsAPISwift.Category?) -> UIColor {
        guard let category = category else { return UIColor.black }
        
        var color: UIColor!
        
        switch category {
        case .business:
            color = UIColor(r: 44, g: 62, b: 80)
        case .entertainment:
            color = UIColor(r: 46, g: 204, b: 113)
        case .gaming:
            color = UIColor(r: 52, g: 152, b: 219)
        case .general:
            color = UIColor(r: 231, g: 76, b: 60)
        case .music:
            color = UIColor(r: 220, g: 48, b: 35)
        case .politics:
            color = UIColor(r: 127, g: 140, b: 141)
        case .scienceAndNature:
            color = UIColor(r: 255, g: 166, b: 49)
        case .sport:
            color = UIColor(r: 211, g: 84, b: 0)
        case .technology:
            color = UIColor(r: 155, g: 89, b: 182)
        }
        
        return color
    }
}

struct Fonts {
    static let cellTitleFont = UIFont.boldSystemFont(ofSize: 14.0)
    static let cellDescriptionFont = UIFont.systemFont(ofSize: 13.0)
    static let cellInformationFont = UIFont.systemFont(ofSize: 10.0)
}

