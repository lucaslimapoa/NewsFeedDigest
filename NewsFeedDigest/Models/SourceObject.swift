//
//  SourceObject.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/29/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RealmSwift
import NewsAPISwift

class SourceObject: Object {
    
    dynamic var id = ""
    dynamic var name = ""
    dynamic var sourceDescription = ""
    dynamic var category = ""
    dynamic var language = ""
    dynamic var country = ""
    dynamic var isFavorite = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(source: NewsAPISource) {
        self.init()
        
        if let id = source.id {
            self.id = id
        }
        
        if let name = source.name {
            self.name = name
        }
        
        if let sourceDescription = source.sourceDescription {
            self.sourceDescription = sourceDescription
        }
        
        if let category = source.category {
            self.category = category.rawValue
        }
        
        if let language = source.language {
            self.language = language.rawValue
        }
        
        if let country = source.country {
            self.country = country.rawValue
        }
    }
    
    func convertToNewsAPI() -> NewsAPISource {
        return NewsAPISource(id: self.id, name: self.name, sourceDescription: self.sourceDescription, url: "", category: Category(rawValue: self.category)!, language: Language(rawValue: self.language)!, country: Country(rawValue: self.country)!, sortBysAvailable: [.top])
    }
}
