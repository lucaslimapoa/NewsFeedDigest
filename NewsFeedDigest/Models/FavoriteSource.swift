//
//  FavoriteSource.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/28/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RealmSwift
import NewsAPISwift

class FavoriteSource: Object {
    dynamic var id = ""
    
    convenience init(sourceId: SourceId) {
        self.init()
        self.id = sourceId
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
