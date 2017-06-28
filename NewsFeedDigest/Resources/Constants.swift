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
    static let appTint = UIColor(r: 244, g: 67, b: 54)
    static let notFavoriteTint = UIColor.gray
    static let favoriteTint = UIColor.yellow
    
    static func color(for category: NewsAPISwift.Category?) -> UIColor {
        guard let category = category else { return UIColor.black }
        
        var color: UIColor!
        
        switch category {
        case .business:
            color = UIColor(r: 26, g: 188, b: 156)
        case .entertainment:
            color = UIColor(r: 46, g: 204, b: 113)
        case .gaming:
            color = UIColor(r: 52, g: 152, b: 219)
        case .general:
            color = UIColor(r: 155, g: 89, b: 182)
        case .music:
            color = UIColor(r: 241, g: 196, b: 15)
        case .politics:
            color = UIColor(r: 52, g: 73, b: 94)
        case .scienceAndNature:
            color = UIColor(r: 231, g: 76, b: 60)
        case .sport:
            color = UIColor(r: 189, g: 195, b: 199)
        case .technology:
            color = UIColor(r: 230, g: 126, b: 34)
        }
        
        return color
    }
}

struct Fonts {
    static let cellTitleFont = UIFont.boldSystemFont(ofSize: 14.0)
    static let cellDescriptionFont = UIFont.systemFont(ofSize: 13.0)
    static let cellInformationFont = UIFont.systemFont(ofSize: 10.0)
}

