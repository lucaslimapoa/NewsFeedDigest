//
//  ArticleSection.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 7/9/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxDataSources
import NewsAPISwift

struct ArticleSection {
    var header: String
    var items: [Item]
    var color: UIColor
    var sourceId: SourceId
}

extension ArticleSection: SectionModelType {
    
    typealias Item = ArticleObject
    
    init(original: ArticleSection, items: [Item]) {
        self = original
        self.items = items
    }
    
}
