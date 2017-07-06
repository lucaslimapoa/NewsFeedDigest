//
//  ArticleObject.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 7/5/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RealmSwift
import NewsAPISwift

class ArticleObject: Object {
    
    dynamic var sourceId = ""
    dynamic var author = ""
    dynamic var title = ""
    dynamic var articleDescription = ""
    dynamic var url = ""
    dynamic var urlToImage = ""
    dynamic var timeInterval: Double = 0
    
}

extension ArticleObject {
    
    convenience init(article: NewsAPIArticle) {
        self.init()
        
        sourceId = article.sourceId ?? ""
        author = article.author ?? ""
        title = article.title ?? ""
        articleDescription = article.articleDescription ?? ""
        url = article.url?.absoluteString ?? ""
        urlToImage = article.urlToImage?.absoluteString ?? ""        
    }
    
}
