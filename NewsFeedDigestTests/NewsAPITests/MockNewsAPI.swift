//
//  MockNewsAPI.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/21/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import NewsAPISwift

class MockNewsAPI: NewsAPI {
    
    override func getArticles(sourceId: SourceId, sortBy: SortBy?, completionHandler: @escaping (Result<[NewsAPIArticle]>) -> Void) {
        
        switch sourceId {
        case "valid-id":
            completionHandler(Result.success(createMockArticles()))
        default:
            completionHandler(Result.error(NewsAPIError.invalidUrl))
        }
    }
}

func createMockArticles() -> [NewsAPIArticle] {
    return [
        NewsAPIArticle(sourceId: "valid-id", author: nil, title: "Mock 1", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: ""),
        NewsAPIArticle(sourceId: "valid-id", author: nil, title: "Mock 2", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: "")
    ]
}